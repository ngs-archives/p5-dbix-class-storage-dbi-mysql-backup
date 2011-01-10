use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use Test::More;
use DBIx::Class::Storage::DBI::mysql;

BEGIN { use_ok 'DBIx::Class::Storage::DBI::mysql::backup' }

{
    is ref(DBIx::Class::Storage::DBI::mysql->new->can('backup')), 'CODE';
    is ref(DBIx::Class::Storage::DBI::mysql->new->can('dump')), 'CODE';
}

done_testing;

