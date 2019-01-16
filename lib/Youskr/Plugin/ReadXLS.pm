package Youskr::Plugin::ReadXLS;
use Mojo::Base 'Youskr::Plugin';

use Spreadsheet::Read qw/ReadData rows/;

sub register {
	my ($self, $projs, @args) = @_;
	$projs->add_helper(readxls => \&_readxls);
}

sub _readxls{
	my ($projs, $xls) = @_;

	my @rows = rows ReadData($xls)->[1];
	my @head = @{shift @rows};
	my $line=1;
	foreach my $row (@rows){
		my %item = map {$head[$_], $row->[$_]} 0..$#head;
		$projs->log->warn("Error from $xls line", ++$line)
			unless $projs->add_item(\%item);
	}

	return $projs;
}

1;