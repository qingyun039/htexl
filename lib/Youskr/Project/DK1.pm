package Youskr::Project::DK1;
use Mojo::Base 'Youskr::Project';

use Mojo::Loader qw/data_section/;
use List::Util qw/sum/;

has name => '皮肤基础管理（美容)';

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
		/
	];
}

sub _data{
	my $self = shift;
	my $data;

	my @line = split /\n/, data_section(ref $self || $self)->{'DK1.txt'};
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

	return $data;
}


1;

__DATA__

@@ DK1.txt
抗氧化	NFE2L2	rs35652124	TT 	3	TC	2	CC	1
抗氧化	NQO1	rs1800566	GG	3	GA	2	AA	1
抗氧化	SOD2	rs4880	AA	3	AG	2	GG	1
抗氧化	CAT	rs1001179	TT 	3	TC	2	CC	1
白皙	MC1R	rs1805007	CC	3	CT	2	TT	1
抗斑	MC1R	rs1805007	CC	3	CT	2	TT	1
抗皱纹	STXBP5L	rs322458 	CC	3	CT	2	TT	1
抗皱纹	MMP1	rs1799750 	CC	3	C-	2	--	1
敏感肌肤	NCF4	rs4821544	CC	3	CT	2	TT	1
锁水	AQP3	rs17553719	TT 	3	TC	2	CC	1
