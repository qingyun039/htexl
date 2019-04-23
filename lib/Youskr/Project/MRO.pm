package Youskr::Project::MRO;
use Mojo::Base 'Youskr::Project';

use Mojo::File 'path';
use File::Basename;
use DBM::Deep;
use Mojo::Loader qw/data_section/;
use List::Util qw/sum/;
use Youskr::Project::DK1;

has name => '精准皮肤管理';

sub _have{
	return +[
		qw/rs35652124
			rs1800566
			rs4880
			rs1001179
			rs1805007
			rs322458 
			rs1799750 
			rs4821544
			rs17553719
			rs6420424
			rs7501331
			rs602662
			rs41281112
			rs1801133
			rs4654748
			rs33972313
			rs7944926
			rs2282679
			rs2108622
			rs1801394
			rs1801131
		/
	];
}


sub _data{
	my $self = shift;
	my $data;


	# DK1
	my @line = split /\n/, data_section("Youskr::Project::DK1")->{'DK1.txt'};
	for(@line){
		my @arr = split /\s+/, $_;
		push @{$data->{$arr[0]}{genes}},[@arr[1,2],$self->{$arr[2]},  # gene rs genotype risk
			$self->{$arr[2]} eq $arr[3] ? $arr[4] : 
				$self->{$arr[2]} eq $arr[7] ? $arr[8] : $arr[6]
		]
	}

	foreach my $item (keys %$data){
		my $risk = sum (map {$_->[3]} @{$data->{$item}{genes}});
		$data->{$item}{risk} = sprintf "%.1f", $risk / @{$data->{$item}{genes}};
	}

	# MBL

	my $p = path((dirname __FILE__), 'MBL')->child('mbl.db');
	my $risk_db = DBM::Deep->new("$p");
	my @mbl = qw/维生素A
				维生素B12
				维生素B2 
				维生素B6
				维生素C 
				维生素D
				维生素E
				叶酸代谢/;

	foreach my $mbl (@mbl){
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