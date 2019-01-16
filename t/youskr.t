#!/usr/bin/perl
use lib '../lib';
use Youskr::Projects;
use Test::More;
use Data::Dumper;
use utf8;   # 重要, Mojo::Base 默认utf8
#use open OUT => ':crlf';

my $xls = '/proj/auto_rep/lib/AutoRep/Project/JTK02/FHP1807090010_20180705-HR-JTK02.xls';
my $projs = Youskr::Projects->new;
can_ok($projs, 'add_helper');
can_ok($projs, 'plugin');
$projs->plugin('ReadXLS');
$projs->readxls($xls);

my $test_proj = $projs->items->first;
isa_ok($test_proj, "Youskr::Project");
isa_ok($test_proj, "Youskr::Project::JTK02");
can_ok($test_proj, '_have','_data','stash', 'stash_json');

print Dumper($test_proj->stash_json);

#my $pdf = $test_proj->process("test.pdf")->process_out;
#like($pdf, qr/test\.pdf/, 'process finish');

done_testing();

