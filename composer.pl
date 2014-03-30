use Plack::Builder;

use lib 'app_test1/lib';
use lib 'app_test2/lib';

use Mojo::Server::PSGI;
use Plack::Session::Store;
use Data::Dumper;

my $app1, $app2;

{ 
  my $server = Mojo::Server::PSGI->new;
  $server->load_app('./app_test1/script/app_test1');
  $app1 = sub { $server->run(@_) }
}

{ 
  my $server = Mojo::Server::PSGI->new;
  $server->load_app('./app_test2/script/app_test2');
  $app2 = sub { $server->run(@_) }
}

builder {
  enable 'Debug';
  enable 'Session', store => Plack::Session::Store->new();
  enable "Auth::Basic", authenticator => sub {
    my($username, $password, $env) = @_;
    if ( $username eq 'guest' && $password eq 'guest' ) {
      $env->{'psgix.session'}->{'username'} = $username;
      return 1;
    }
  };
  mount "/test1" => builder { $app1 };
  mount "/test2" => builder { $app2 };
};
