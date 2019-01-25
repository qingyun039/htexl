package Youskr::Project::SGYG;
use Mojo::Base 'Youskr::Project';

use Mojo::File 'path';
use File::Basename;
use List::Util 'reduce';
use Storable;

has name => '三高易感基因检测';

sub _have {
	return +[qw/
		rs1042714
		rs10830963
		rs12255372
		rs1805762
		rs2237892
		rs328
		rs3755351
		rs429358
		rs4343
		rs560887
		rs5742904
		rs699
		rs7412
		rs7566605
		rs9939609
	/];
}

sub _data{
	my $self = shift;
	my $data;

	my $p = path((dirname __FILE__), (basename __FILE__,'.pm'))->child('sgyg.Pdata');
	
	my $guide = retrieve($p);
	$data->{dinfo} = $guide;
	while (my ($dis, $rss) = each(%$guide)){
		$data->{dlist}{$dis} = [reduce {$a * $b} map { $rss->{$_}{$self->{$_}} } keys %$rss];
		$data->{dlist}{$dis}[1] = levelRisk($data->{dlist}{$dis}[0]);
	}

	return $data;
}

sub levelRisk{
	my $risk = shift;
	return '低风险' if $risk < 0.8;
	return '中风险' if $risk < 1.2;
	return '高风险';
}


1;