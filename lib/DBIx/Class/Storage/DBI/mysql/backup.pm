package DBIx::Class::Storage::DBI::mysql::backup;

use strict;
use warnings;

use DBIx::Class::Storage::DBI;
use DateTime;
use MySQL::Backup;
use File::Path qw/mkpath/;

sub import {
    *DBIx::Class::Storage::DBI::dump = \&_dump;
    *DBIx::Class::Storage::DBI::backup = \&_backup;
}

sub _backup {
    my ( $self, $dir ) = @_;

    mkpath([$dir]) unless -d $dir;
    

    my $dsn = $self->_dbi_connect_info->[0];
    my $dbname = $1 if($dsn =~ /^dbi:mysql:database=([^;]+)/i);
    unless($dbname) {
        $dbname = $1 if($dsn =~ /^dbi:mysql:([^;]+)/i);
    }
    $self->throw_exception("Cannot determine name of mysql database")
        unless $dbname;
    
    my @lt = localtime;
    
    my $filename = sprintf(
        "%s-%04d%02d%02d-%02d%02d%02d.sql",
        $dbname,
        $lt[5]+1900, $lt[4]+1, $lt[3],
        $lt[2], $lt[1]+1, $lt[0],
    );
    
    open  OUT, ">$dir/$filename";
    print OUT $self->dump;
    close OUT;
    
    $filename
}

sub _dump {
    my $self = shift;
    my $mb = MySQL::Backup->new_from_DBH( $self->dbh ,{'USE_REPLACE' => 1, 'SHOW_TABLE_NAMES' => 1});
    $mb->create_structure() . $mb->data_backup()
}


1