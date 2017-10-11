#!/usr/bin/perl

# "Date","Description","Original Description","Amount","Transaction Type","Category","Account Name","Labels","Notes"
# "3/11/2017","Sweet Corner","Pending DEBIT AUTHORIZATION Mar11 08:58a 1870 AT 08:58 Sweet Corner New York NY","3.75","debit","Groceries","Checking","",""

use strict;

my $header = <>;

print "DROP TABLE IF EXISTS `account`;\n";
print "CREATE TABLE `account` (`date` date, `y` smallint, `m` tinyint, `d` tinyint, `descr` varchar(256), `bdescr` varchar(256), `cat` varchar(256), `type` varchar(256), `amt` int);\n";

while(<>) {
    chomp();
    my @fields = split(/,/);
    foreach(@fields) {
        s/^"//;
        s/"$//;
        s/""/"/g;
        s/'/\\'/g;
    }
    my ($date,$descr,$bdescr,$amt,$ttype,$cat,$acct,$labels,$notes) = @fields;
    my ($y,$m,$d);
    $amt *= 100;
    $date =~ s|(\d+)/(\d+)/(\d\d\d\d)|${3}-${1}-${2}|;
    ($y,$m,$d) = split(/-/,$date);
    print "INSERT INTO `account` (`date`,`y`,`m`,`d`,`descr`,`bdescr`,`cat`,`type`,`amt`) VALUES (DATE('$date'), $y, $m, $d, '$descr', '$bdescr', '$cat', '$ttype', $amt);\n";
}

# Make views
print "DROP VIEW IF EXISTS `annual`;\n";
print "CREATE VIEW `annual` AS SELECT `y`,`cat`,TRUNCATE(SUM(`amt`)/100,0) AS `spend` FROM `account` WHERE `type` = 'debit' GROUP BY `y`,`cat`;\n";
