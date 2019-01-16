package Youskr::Project::SGYY;
use Mojo::Base 'Youskr::Project';

use Mojo::UserAgent;

has name =>'高血压安全用药';

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
	for my $i (@{$rj->{catalog}}){
		push @{$data->{shopNames}}, $i->{shopName};
		$data->{slist}{$i->{shopName}} = $i;
	}
	for my $j (@{$rj->{item_details}}){
		push @{$data->{component}}, $j->{chemical_name};
		$data->{clist}{$j->{chemical_name}} = $j;
	}

	return $data;
}

1;