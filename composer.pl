use Plack::Builder;

use lib 'app_test1/lib';
use lib 'app_test2/lib';

use Mojo::Server::PSGI;
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
  enable "Auth::Basic", authenticator => sub {
    my($username, $password) = @_;
    return $username eq 'admin' && $password eq 'foobar';
  };
  mount "/test1" => builder { $app1 };
  mount "/test2" => builder { $app2 };
};
