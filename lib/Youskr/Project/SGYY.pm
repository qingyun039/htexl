package Youskr::Project::SGYY;
use Mojo::Base 'Youskr::Project';

use Mojo::UserAgent;
use Storable;

has name => '高血压安全用药';

has repo => sub {Mojo::File->new(__FILE__)->sibling};

sub _have {
	return +[]
}

sub _data {
	my $self = shift;
	my $data;

	my %types = (XY => 252, XT => 253, XZ => 254);
	my $sampleid = $self->{'条形码'};
	my $type = $types{$self->{'检测项目'}};
	my $url = "http://www.decare.net.cn:81/dingkang/code2/index.php/home/index/report4?type=$type&sample=$sampleid";

	my $rj = Mojo::UserAgent->new->get($url)->result->json;
	
	$data->{slist} = $rj->{catalog};
	for my $j (@{$rj->{item_details}}){
		push @{$data->{component}}, $j->{chemical_name};
		$data->{clist}{$j->{chemical_name}} = $j;
	}
	$data->{cinfo} = retrieve($self->repo->child('zpxy.Pdata'));  # 放在这里觉得不太合理

	return $data;
}

1;