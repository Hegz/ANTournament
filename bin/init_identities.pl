#!/usr/bin/env perl
#===============================================================================
#
#         FILE: init_identities.pl
#
#        USAGE: ./init_identities.pl
#
#  DESCRIPTION: initilize database and refresh the identites from netrunnerdb
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Adam Fairbrother (), adam.fairbrother@gmail.com
#      VERSION: 1.0
#      CREATED: 19/04/16 12:07:57 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use lib "../perl5/lib/perl5";
use local::lib "../perl5/";
use Cpanel::JSON::XS;
use LWP::Simple;
use Data::Dumper;
use DBI;
use File::Spec;
use File::Slurper qw/ read_text /;

my $database = File::Spec->catfile(File::Spec->updir(), 'ANTournamet.sqlite');
binmode STDOUT, ":encoding(UTF-8)";

sub connect_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=$database") or
        die $DBI::errstr;

    return $dbh;
}

sub init_db {
  my $db = connect_db();
  my $schema = read_text('../schema.sql');
  $db->do($schema) or die $db->errstr;
}

init_db();

# Download the list of cards from netrunner db and convert to a perl structure
my $all_cards_url = 'https://netrunnerdb.com/api/cards';
my $cards_json = get ($all_cards_url);


my $cards_perl = decode_json $cards_json;
for (@{$cards_perl}) {
	# Loop through the cards looking for Idetities
	if (${$_}{type} eq 'Identity') {
		my $db = connect_db();

		# Check if the identity already exists in the database
		my $sql = 'select * from identities where id=(?)';
		my $sth = $db->prepare($sql) or die $db->errstr;
		$sth->execute(${$_}{code});
		unless (defined $sth->fetchrow_arrayref) {
			# Insert the identitiy into the database
			$sql = 'insert into identities (id, title, faction, side ) values (?, ?, ?, ?)';
			$sth = $db->prepare($sql) or die $db->errstr;
			$sth->execute(${$_}{code},${$_}{title},${$_}{faction},${$_}{side});
		}
	}
}
