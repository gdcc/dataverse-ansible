#!/usr/bin/perl

my $pglogfile = shift @ARGV;

unless ( -f $pglogfile )
{
    die "usage: ./count.pl <PGLOGFILE>\n";
}

my $pglogfilesize = (stat($pglogfile))[7];
print "Current size: ".$pglogfilesize." bytes.\n";

system "./parse.pl < $pglogfile > tail.parsed";

system "cat tail.parsed | sed 's/ where.*//' | sed 's/ WHERE.*//' | sed 's/ SET .*//' | sed 's/ VALUES .*//' | sort | uniq -c | sort -nr -k 1,2 > tail.counted";

print "Parsed and counted the queries. Total number:\n";

system "awk '{a+=\$1}END{print a}' < tail.counted";

print "\nQueries, counted and sorted: \n\n";

system "cat tail.counted";
