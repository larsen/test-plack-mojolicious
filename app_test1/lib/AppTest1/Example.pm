package AppTest1::Example;
use Mojo::Base 'Mojolicious::Controller';

use Mojolicious::Sessions::Storable;
use Plack::Session;
use Plack::Session::Store::File;

sub welcome {
  my $self = shift;

  my $session = Plack::Session->new( $self->req->env );

  $self->render(
    message  => 'Hi, I am AppTest1',
    username => $session->get('username'),
    session  => $session
  );
}

1;
