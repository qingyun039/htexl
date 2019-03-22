package Youskr::Project::GAG;
use Mojo::Base 'Youskr::Project';

use Mojo::File 'path';
use File::Basename;
use Storable;

has name => '儿童天赋+成长';

sub _have{
	return +[qw/rs1381566
rs1544410
rs17070145
rs1800497
rs1800955
rs1801260
rs1815739
rs1852469
rs25531
rs363050
rs4680
rs4988235
rs4994
rs6265
rs8192678
rs9854612
rs4988235/
];
}

sub _data{
	my $self = shift;
	my $data;

	my $pdata = retrieve(path((dirname __FILE__), (basename __FILE__,'.pm'))->child('GAG.Pdata'));
	foreach my $item (@$pdata){
		my $hash;
		my ($phenotype, $result, $loci);
		my $counter = 0;  # rs 计数
		$phenotype = (keys %$item)[0];
		foreach my $gene (keys %{$item->{$phenotype}}){
			foreach my $rsid (keys %{$item->{$phenotype}{$gene}}){
				my $criteria = $item->{$phenotype}{$gene}{$rsid};
				my $genotype = $self->{$rsid};
				my $lociresult = {
					rsid => $rsid,
					gene => $gene,
					genotype => $genotype,
				};
				my $genotype_rev = join '', (split //, $genotype)[1,0];
				$lociresult->{value} = $criteria->{$genotype} || $criteria->{$genotype_rev};
				my @genotypes;
				if($lociresult->{value} =~ /^\d+$/){
					$result += $lociresult->{value};
					@genotypes = sort { $criteria->{$a} <=> $criteria->{$b} } keys %$criteria;
				}else{
					$result = $lociresult->{value};
					@genotypes = sort { length $criteria->{$a} <=> length $criteria->{$b} } keys %$criteria;
				}
				$lociresult->{order} = [@genotypes];

				push @$loci, $lociresult;
				$counter++;
			}
		}
		$hash = {
			phenotype => $phenotype,
			result => ($result =~ /^\d+$/ ? sprintf("%d",$result / $counter) : $result),
			loci => $loci
		};
		push @$data, $hash;
	}

	return $data;
}

1;