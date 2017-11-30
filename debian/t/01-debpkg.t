use Test::More qw(no_plan);

my $file = $ENV{DEB_PKG};

isnt( $file, '', 'DEB_PKG env var set');
ok( -f $file, 'file exists');
ok( -s $file > 0, 'file size > 0');



