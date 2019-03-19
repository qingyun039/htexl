package Youskr::Project::TMR;
use Mojo::Base 'Youskr::Project';

use Mojo::File 'path';
use File::Basename;
use DBM::Deep;

has name => '肿瘤筛查';

sub _have{
	my $self = shift;
	return +[];
}

sub _data{
	my $self = shift;
	my $data;

	my $p = path((dirname __FILE__), (basename __FILE__,'.pm'))->child('tmr.db');
	my $risk_db = DBM::Deep->new("$p");
	my @tumors = $self->tumors;
	foreach my $tumor (@tumors){
		my %tmr_h;
		$tmr_h{tumor} = $tumor;
		my $risk = 1;
		foreach my $rs (@{$risk_db->{$tumor}}){
			my %rs_h;
			@rs_h{qw/rsid gene ref alt freq/} = @{$rs}[0...4];
			$rs_h{genotype} = $self->{$rs->[0]};
			$rs_h{risk} = $rs->[&gene_type(@rs_h{qw/rsid gene genotype/})];
			push @{$tmr_h{rss}},\%rs_h;

			$risk *= $rs_h{risk};
		}
		$tmr_h{risk} = sprintf("%.2f", $risk);
		$tmr_h{level} = levelRisk($tmr_h{risk});
		
		push @$data, \%tmr_h;
	}

	return $data;
}

sub tumors {
	my $self = shift;
	if($self->{'检测项目'} =~ /TMR/){
		if($self->{'性别'} eq '女'){
			return qw/肺癌 肝癌 胃癌 结直肠癌 食管癌 脑癌 甲状腺癌 膀胱癌 胰腺癌 乳腺癌 宫颈癌 卵巢癌/;
		}else{
			return qw/肺癌 肝癌 胃癌 结直肠癌 食管癌 脑癌 甲状腺癌 膀胱癌 胰腺癌 前列腺癌/;
		}
	}
}

sub gene_type{
	my ($ref, $alt, $genotype) = @_;
	return $genotype eq $ref.$ref ? 7 : $genotype eq $alt.$alt ? 9 : 8;
}

sub levelRisk{
	my $risk = shift;
	return '低风险' if $risk < 0.8;
	return '中风险' if $risk < 1.2;
	return '高风险';
}

1;