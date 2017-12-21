use Test::More qw(no_plan);

my $file = $ENV{DEB_PKG};

isnt( $file, '', 'DEB_PKG env var set');
ok( -f $file, 'file exists');
ok( -s $file > 0, 'file size > 0');

open(my $fh, '-|', "dpkg-deb -c $file") or die "Error running dpkg-deb: $!";

my @files = sort map { chomp, [split(/\s+/, $_)] } <$fh>;
my @expect_files = qw(
    ./
    ./usr/local/include/mumlib.hpp
);

is_deep( \@files, [ ['./usr/local/include/mumlib.hpp'] ], 'check package contents');




