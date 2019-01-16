##########################################
# 模块名：Youskr::Routes
# 版本：0.1.0
# 作者：qingyun039
# 描述：
#       
#
# 修改：0
# #########################################
package Youskr::Routes;
use Mojo::Base -base;
use Data::Dumper;

use Youskr::Projects;
use Smart::Match qw/contains/;
use Mojo::Loader qw/load_class find_modules find_packages/;

has projects => sub{ Youskr::Projects->new };

has namespace => sub{ ['Youskr::Project'] };

has pkey => '检测项目';

has matches => sub { [qr/^rs\d+/, qr/^jtk\d+/] };

has roles => sub { [ '+Default' ]};

sub route{
    my ($self, $item) = @_;
    
    my $log = $self->projects->log;
    $log->warn("Item must in hashref"), return unless(ref $item eq 'HASH');
    
    # 确定项目代码
    my $pcode;
    # 哈希中指定了项目代码
    if($item->{pcode}){
		$pcode = $item->{pcode};
	# 哈希中pkey对应的域的值为项目代码
    }elsif($item->{$self->pkey}){
			$pcode = $self->with_roles($_)->findc($item->{$self->pkey}) and last for (@{$self->roles});
			$log->warn("Unkown Project Code: ".$item->{$self->pkey}) unless $pcode;
	# 根据哈希中的rsid猜测项目代码
    }else{
    	my @maybe_pcodes;
		$log->warn("find project ...");
		# 获取所有项目中必须有的snp的哈希，如{DRG => ['rs1234',..], MBL => ['rs2345',...]};
		my %all;
		for my $ns (@{$self->namespace}){     # 只要[namespace]下的项目
	    	$all{substr $_, length "${ns}::"} //= $_->_have 
			for grep { _project($_) } find_modules($ns), find_packages($ns);
		}
		while( my ($key, $val) = each %all ){
	    	my @l1 = keys %$item;
	    	my @l2 = @$val;
	    	push @maybe_pcodes, $key if(@l1 ~~ contains(@l2));  # 如果哈希中提供的rsid包含项目中所需的rsid
		}

		# 如果找到多个项目, 选择第一个
		$pcode = shift @maybe_pcodes;
		$log->warn("I cannot guest what project it is") and return unless $pcode;
		
		if(@maybe_pcodes){
		    my $pcodes = join ", ", @maybe_pcodes;
		    $log->warn("maybe you want generate thoes project's report: $pcodes\nplease use --pcode to specify\n");
		}
		
		$log->warn("I guest the project is: $pcode");
    }

    # 知道了项目代码, 根据哈希生成项目对象
    my $module;
    $module = _project("${_}::$pcode", 1) and last for @{$self->namespace};
    $log->warn("Unkown Project Module: $pcode") unless $module;

    my $project = $module->new($item); # Mojo::Base 的特性, 可传入哈希引用.
#    $self->projects->add_item($project);

    return $project->validate($pcode) ? $project : undef;     # 返回什么好呢？ 返回项目对象, 减少两个类的依赖
}

sub _project{
    my ($module, $fatal) = @_;
    return $module->isa('Youskr::Project') ? $module : undef
	unless my $e = load_class $module;
    $fatal && ref $e ? die $e : return undef;
}

1;
