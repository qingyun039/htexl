package Htexl::Controller::Report;
use Mojo::Base 'Mojolicious::Controller';

use Htexl::Model::SNPresult;
use Youskr::Projects;

has model => sub { Htexl::Model::SNPresult->new(pg => $_[0]->pg) };

has projs => sub { Youskr::Projects->new };

sub index{
	my $c = shift;
	$c->render;
}

# 检测结果上传
sub upload {
	my $c = shift;
	
	my $v = $c->validation;
	if($v->required('snp_result')->upload->is_valid){
		my $upload = $c->param('snp_result');
		my $name = $upload->filename;
		my $xlsfile = $c->app->config->{'upload_dir'}->child("xls",$name)->to_string;
		print $xlsfile;
		if($upload->move_to($xlsfile)){
			my $rt = $c->model->xlstoDB($xlsfile);
			return $c->render(text => "检测结果: $name 导入数据库成功") if $rt;
			return $c->render(text => '检测结果: $name 导入数据库出现错误')
		}
	}
}

# 检测列表
sub list {
	my $c = shift;

	$c->stash(list => $c->model->listItem);
	return $c->render();
}

sub report{
	my $c = shift;

	my $pcode = $c->param('pcode');
	my $sampleid = $c->param('sampleid');
	my $item = $c->model->fetchItem($pcode, $sampleid);
	$c->projs->add_item($item);
	$c->stash(%{$c->projs->items->first->stash})->style;
	
	my $sdata = {};
	@{$sdata}{qw/item result style/} = @{$c->stash}{qw/item result style/};

	my $template = $c->stash('style')->{template};
	$c->respond_to(
	    json => { json => $sdata },
	    html => { template => "$template/main" },
	    pdf  => { template => "$template/main" },
	    tex  => { template => "$template/main", format =>'pdf', handler => 'ltx', latex => 1 },
	);
}


1;
