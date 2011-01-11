use strict;
use warnings;
use FindBin::libs;

use Test::More;
use Test::mysqld;
use Symbol;

BEGIN {
    use_ok 'DBICTest::Schema';
    use_ok 'DBIx::Class::Storage::DBI::mysql::backup';
}

my $mysqld = Test::mysqld->new(
    my_cnf => { 'skip-networking' => '' },
) or plan skip_all => $Test::mysqld::errstr;


{
    my $schema = DBICTest::Schema->connect($mysqld->dsn(dbname => 'test'));
    $schema->deploy;
    my $artist_rs = $schema->resultset('Artist');
    my $cd_rs = $schema->resultset('CD');
    
    my ($backup_file, $artist, $cd);
    
    $artist = $artist_rs->create({
        name => 'foo',
    });
    
    $cd = $cd_rs->create({
        title => 'album1',
        artist => $artist,
    });
    
    $cd = $cd_rs->create({
        title => 'album2',
        artist => $artist,
    });
    
    my $dump = $schema->storage->dump;
    ok $dump;
    
    $backup_file = $schema->backup;
    ok $backup_file;
    
    my $target = $schema->backup_directory."/$backup_file";
    ok -f $target, "backup file exists to $target";
    my $fh = Symbol::gensym();
    open $fh, $target or fail($!);
    local $/ = undef;
    my $read = <$fh>;
    close $fh;
    is $read, $dump;
}

done_testing;
