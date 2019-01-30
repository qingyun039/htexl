package Mojolicious::Plugin::LaTeXRep;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

use Mojo::File 'path';
use LaTeX::Driver;

sub register {
  my ($self, $app) = @_;


  # Append "templates" and "public" directories
  my $base = path(__FILE__)->sibling('LaTeXRep');
  push @{$app->renderer->paths}, $base->child('templates')->to_string;
  push @{$app->static->paths},   $base->child('public')->to_string;

  
  # add after_render hook
  $app->hook(after_render => sub {
    my ($c, $output, $format) = @_;
#    print $$output;
    return $_[2] = 'txt' if($c->stash('latex'));
    if($format eq 'pdf'){
      LaTeX::Driver->new(
      	source => $output,
      	output => $output,
      	format => 'pdf',
        texinputs => [$base->child('public'),$base->child('public')->list({dir=>1})->grep(sub{-d})->each],
      )->run;
    }
  });

  # Customing template syntax
  $app->plugin('EPRenderer', { 
			    name => 'ltx',
			    template => { 
    				tag_start => '<!',
    				tag_end => '!>',
    				line_start => '!',
			    },
		});
    
  # helper
  $app->helper(style => \&_style);
}

sub _style{
  my ($c,$query) = (shift, shift);
  my $style = {};

  if($query){
    $c->req->url->query($query);
  }
  # 寻找模板
  $style->{template} = $c->stash->{item}{'检测项目'};
  # 其它与模板相关的参数
  $style = { %$style, %{$c->req->params->to_hash} };
  $c->stash(style => $style);
  return $c;
}

1;


__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::LaTeXRep - 用LaTeX生成PDF报告

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('LaTeXRep');

  # Mojolicious::Lite
  plugin 'LaTeXRep';

=head1 DESCRIPTION

L<Mojolicious::Plugin::LaTeXRep> is a L<Mojolicious> plugin. 它为应用添加
一个L<after_render>的hook，使模板在渲染后，在用LaTeX::Driver模块编译生成PDF

=head1 METHODS

L<Mojolicious::Plugin::LaTeXRep> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
