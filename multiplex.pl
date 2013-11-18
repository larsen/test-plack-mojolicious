use Plack::Builder;

use lib 'app_test1/lib';
use lib 'app_test2/lib';

use Mojo::Server::PSGI;
use AppTest1;
use AppTest2;
use Data::Dumper;

# my $app = sub { $psgi->run(@_) };
# my $app = $server->load_app('./myapp.pl');

my $app1, $app2;

# AppTest1
{ 
  my $server = Mojo::Server::PSGI->new;
  my $_app = $server->load_app('./app_test1/script/app_test1');
  $app1 = sub { $server->run(@_) }
}

# AppTest2
{ 
  my $server = Mojo::Server::PSGI->new;
  my $_app = $server->load_app('./app_test2/script/app_test2');
  $app2 = sub { $server->run(@_) }
}

builder {
  enable 'Debug';
  mount "/test1" => builder { $app1 };
  mount "/test2" => builder { $app2 };
};
