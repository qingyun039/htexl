##########################################
# 模块名：Youskr::Projects
# 版本：0.1.0
# 作者：qingyun039
# 描述：
#       
#
# 修改：0
# #########################################
package Youskr::Projects;
use Mojo::Base -base;
use Data::Dumper;

use Youskr::Routes;
use Mojo::Collection;
use Mojo::Log;
use Scalar::Util 'blessed';
use Mojo::Loader qw/load_class/;
use Mojo::DynamicMethods -dispatch;


=attr project_class

该管理类只管理以 project_class 为基类的项目

=cut

has project_class => 'Youskr::Project';

=attr routes

routes|路由 负责根据数据生成对应的项目

=cut

has routes => sub { Youskr::Routes->new(projects => $_[0]) }; 

=attr items

items: 项目仓库，一个L<Mojo::Collectin>对象，包含目前
要处理的所有项目

=cut

has items => sub { Mojo::Collection->new };

=attr log

日志记录，L<Mojo::Log>对象。

=cut

has log => sub { Mojo::Log->new };

=method add_helper plugin

add_helper, plugin copy from Mojolicious;

=cut


sub BUILD_DYNAMIC {
    my ($class, $method, $dyn_methods) = @_;
    
    return sub {
      my ($self, @args) = @_;
      my $dynamic = $dyn_methods->{$self}{$method};
      return $self->$dynamic(@args) if $dynamic;
      my $package = ref $self;
      die qq{Can't locate object method "$method" via package "$package"};
    };
}

sub add_helper {
  my ($self, $name, $cb) = @_;

  Mojo::DynamicMethods::register 'Youskr::Projects', $self, $name, $cb;
}

sub plugin{
	my ($self, $name) = (shift, shift);

  	for my $class ("Youskr::Plugin::$name", $name) { 
  		my $object = $class->new if _load($class);
  		if($object){
  			$object->register($self, @_);
  			return;
  		}
  	}

  	# Not found
  	die qq{Plugin "$name" missing, maybe you need to install it?\n};
}

=method add_item

    $projects->add_item($drg, $mbl, $item);

往项目仓库添加一个或多个项目, 可以是哈希引用或Project对象

=cut

sub add_item {
    my $self = shift;

    for my $i (@_){
    	# 如果是一个Project对象, 直接添加到项目列表items中
		if(blessed $i and $i->isa($self->project_class)){
		    push @{$self->items}, $i;
		# 如果是哈希引用, 由route判断是哪个项目对象, 再添加到项目列表items中
		}elsif(ref $i eq 'HASH'){
		    if(my $item = $self->routes->route($i)){
		    	push @{$self->items}, $item;
		    }
		}else{
		    $self->log->warn("Unknow Projct");
		    return undef;
		}
    }

    return $self;
}

=method modify_item

    $projects->modify_item({logo => 'genetechlogo.png'}, {'条形码' => 'JTK20181031'});

对仓库中符合条件的项目进行修改

=cut

sub modify_item{
    my $self = shift;
    my ($change, $condition) = @_;

    foreach my $item (@{$self->items}){
		my $match = 1;
		foreach my $key (keys %$condition){
	    	if($item->{$key} !~ /$condition->{$key}/){
				$match = 0;
	    	}
		}
		if($match){
		    foreach my $key (keys %$change){
				$item->{$key} = $change->{$key};
		    }
		}
    }

    return $self;
}

=method render_all

对仓库中的所有项目进行渲染。
所有项目对象必须有 render 方法

=cut

sub render_all{
    my $self = shift;

    $self->items->each(sub{$_->render});

    return $self;
}

=method process_all

对仓库中的所有项目进行编译
所有项目对象必须有 process 方法

=cut

sub process_all{
    my $self = shift;

    $self->items->each(sub{$_->process});

    return $self;
}

sub _load {
	my $module = shift;
	return $module->isa('Youskr::Plugin') unless my $e = load_class $module;
	ref $e ? die $e : return undef;
}


1;
