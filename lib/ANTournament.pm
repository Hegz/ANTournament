package ANTournament;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/Pairings' => sub {

    template 'index';
};

get '/Players' => sub {
    template 'index';
};


true;
