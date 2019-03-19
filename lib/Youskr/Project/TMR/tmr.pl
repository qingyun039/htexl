#!/usr/bin/perl
use strict;
use warnings;
use DBM::Deep;
use Spreadsheet::Read qw/ReadData rows/;
use Data::Dumper;

my $srcxlsx = "/proj/auto_rep/lib/AutoRep/Project/TMR/TMRrule.xlsx";
my $savedb = "tmr.db";
my $dbm = DBM::Deep->new($savedb);
$dbm->clear;
my @data = rows ReadData($srcxlsx)->[1];
shift @data;
for(@data){
    my @c = @$_;
    $c[3] =~ s/\(.*$//g if $c[3];
    my @risk = calcrisk($c[8], $c[11]);
    print join ',', @risk;
    print "\n";
    push @{$dbm->{$c[0]}},[ $c[1], $c[3] || '', $c[6], $c[7],$c[8],$c[11], @risk ];
}
print Dumper($dbm);


# 传入突变型的基因频率, 对应的OR值, 得到平均风险, 野生纯合风险, 杂合风险, 突变纯合风险
sub calcrisk {
    my ($Bf, $or) = @_;
    my $Af = 1 - $Bf;
    my $avg_risk = $Af*$Af + 2*$Af*$Bf*$or + $Bf*$Bf*$or*$or;
    return ($avg_risk, 1/$avg_risk, $or/$avg_risk, $or*$or/$avg_risk);
}
