package Htexl;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;

# This method will run once at server start
sub startup {
  my $self = shift;

  # 开发测试不用缓存
  $self->renderer->cache->max_keys(0);

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # 增加渲染LaTeX成PDF的功能
  $self->plugin('LaTeXRep');

  # 
  $self->helper(pg => sub { state $pg = Mojo::Pg->new($config->{pgsql}) } );


  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/report')->to('report#index');
  $r->get('/report/list')->to('report#list');
  $r->get('/report/upload')->to('report#upload');
  $r->post('/report/upload')->to('report#upload');
  $r->get('/report/:pcode/:sampleid')->to('report#report');
}

1;
