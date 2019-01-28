package Mojolicious::Command::report;
use Mojo::Base 'Mojolicious::Command';

use Mojo::Util qw/getopt tablify dumper/;
use Mojo::JSON qw(encode_json);
use Mojo::File;

use Htexl::Model::SNPresult;
use Youskr::Projects;

has description => "生成报告";

has usage => sub { shift->extract_usage };

has projs => sub { Youskr::Projects->new };

has db => sub { Htexl::Model::SNPresult->new(pg => shift->app->pg) };

sub run{
	my ($self, @args) = @_;

	$self->app->mode('production');

	getopt \@args,
	    'x|xls=s' => \my $xls,
	    't|tex'   => \my $tex, 
	    'j|json'  => \my $json,
	    'a|arid=s' => \my @arid, 
	    'p|psql'       => \my $psql,
	    'l|list=i'       => \my $list,
	    'o|outdir=s'       => \my $outdir,
	    'd|debug' => \my $debug;

	if($list){
		my $items = $self->db->listItem;
		my @l = map {[@{$_}{qw/id 条形码 姓名 送检单位 检测项目/}]} @$items;
		print tablify(\@l);
		return;
	}
	if($xls){
		$self->projs->plugin('ReadXLS');
		$self->projs->readxls($xls);
		if($psql){              # 导入数据库
			$self->db->xlstoDB($xls);
		}
	}
	if(@arid){
		foreach my $id (@arid){
			my $item = $self->db->getItem($id);
			$self->projs->add_item($item);
		}
	}

	my $format = 'pdf';
	$self->app->defaults(format=>$format);
	$self->projs->items->map(sub{
		my $output;
		
		if($json){
			$output = encode_json($_->stash);
		}else{
			my $c = $self->app->build_controller->stash(%{$_->stash});	
			# 这里为什么要encode????
			$output = $c->render_to_string(template => $self->app->tpl($_->{'检测项目'})."/main" )->encode('utf8')->to_string;
			return $output unless($outdir);
			my $mf = Mojo::File->new($outdir);
			
			unless($tex){
				$self->app->plugins->emit_hook(after_render => $c, \$output, $format);
				return $mf->child($_->{'条形码'}.$_->{'检测项目'}.'.pdf')->spurt($output)->to_abs;
			}
			return $mf->child($_->{'条形码'}.$_->{'检测项目'}.'.tex')->spurt($output)->to_abs;
		}
		return $output;
	})->each(sub{print});

}

1;

=head1 SYNOPSIS
   
   Usage: ./htexl report [OPTIONS]

   Options:
     -h, --help               print this message
     -x, --xls <string>       从xls表生成报告
     -p, --psql               指定-x并指定该选项，同时将xls表导入数据库
     -t, --tex                输出tex源码, 而不是默认的pdf文件
     -j, --json               输出为json格式
     -a, --arid <string>      指定数据id，生成该数据的报告
     -l, --list <number>      列出数据库中前n条检测结果
     -o, --output <string>    输出文件名
     -d, --debug              开启调试

=cut 