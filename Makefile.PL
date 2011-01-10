use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::Storage::DBI::mysql::backup',
    AUTHOR              => q{Atsushi Nagase <ngs@cpan.org>},
    VERSION_FROM        => 'lib/DBIx/Class/Storage/DBI/mysql/backup.pm',
    ABSTRACT_FROM       => 'lib/DBIx/Class/Storage/DBI/mysql/backup.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl') : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'DBIx::Class' => 0,
        'DBIx::Class::Storage::DBI::mysql' => 0,
        'MySQL::Backup' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-Storage-DBI-mysql-backup-*' },
);
