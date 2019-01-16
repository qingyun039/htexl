package Youskr::Plugin;
use Mojo::Base -base;

use Carp 'croak';

sub register { croak 'Method "register" not implemented by subclass' }

1;