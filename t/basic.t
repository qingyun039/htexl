use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use lib '../lib';

plugin 'LaTeXRep';

get '/' => sub {
  my $c = shift;
  $c->render('template' => 'test/main', format => 'pdf', handler => 'ltx');
};

#app->start;
my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_type_is('application/pdf');

done_testing();

__DATA__

@@ layouts/default.pdf.ep
\documentclass{ctexart}
\begin{document}
<%= content %>
\end{document}

@@ hello.pdf.ep
% layout 'default';

\textit{me:} Hello, World！

%= include 'world';

@@ world.pdf.ep
\textit{world:} Hello, Sir!
