package Youskr::Project::MBL;
use Mojo::Base 'Youskr::Project';

use Mojo::File 'path';
use File::Basename;
use DBM::Deep;

has name => '全面代谢';

sub _have{
	my $self = shift;
	return +[
	qw/rs174575	rs1050450	rs13266634	rs1544410	rs3736228	rs1799983	rs1229984	rs671	rs182549	rs4988235	rs855791	rs1801131	rs2282679	rs2108622	rs1801133	rs6420424	rs7501331	rs602662	rs41281112	rs4654748	rs33972313	rs7944926	rs1801394/
	];
}

sub _data{
	my $self = shift;
	my $data;

	my $p = path((dirname __FILE__), (basename __FILE__,'.pm'))->child('mbl.db');
	my $risk_db = DBM::Deep->new("$p");
	foreach my $mbl (keys %$risk_db){
		my $genetic = $risk_db->{$mbl};
		my @genes = split /\+/, $genetic->[0];
		my @rsids = split /\+/, $genetic->[1];
		my @genotypes = @{$self}{@rsids};
		my ($rkey) = grep {
			my @bb = split /\+/,$_;
			my @aa = grep { $self->{$rsids[$_]} eq $bb[$_] or (join '', (split //, $self->{$rsids[$_]})[1,0]) eq $bb[$_]} 0 .. $#bb;
			scalar @aa == scalar @bb;
			} keys %{$genetic->[3]};
		$data->{$mbl}{advice} = $genetic->[3]{$rkey};
		for(my $i=0; $i<@genes; $i++){
			$data->{$mbl}{genes}[$i] = {
				gene => $genes[$i],
				rsid => $rsids[$i],
				genotype => $genotypes[$i]
			};
		}
	}

	return $data;
}

1;