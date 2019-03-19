package Youskr::Routes::Role::Default;
use Mojo::Base -role;

use Smart::Match 'any';
use Mojo::Loader qw/find_modules find_packages/;

has pcodes => sub {
	[map { map { (split /::/, $_)[-1] } find_modules($_), find_packages($_) } @{$_[0]->namespace}];
};

sub findc {
	my ($self, $old_pcode) = @_;
	return 'SGYG' if $old_pcode eq 'DK-E';
	return $old_pcode if $old_pcode ~~ any(@{$self->pcodes});
	return 'SGYY' if $old_pcode ~~ any(qw/XY XT XZ/);
	return 'TMR' if $old_pcode =~ /TMR.+/;
	return undef;
}

1;