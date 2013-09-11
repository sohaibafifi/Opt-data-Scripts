#!/usr/bin/perl -w

use strict;
use warnings;
use Getopt::Long;
use List::Util qw/min max sum/;
# use this to find out what a variable contains. e.g. print Dumper $var;
use Data::Dumper ;
my $folder = 'output';
my $length = @ARGV;
if($length eq 1){
    $folder = $ARGV[0];
}

my @myInstances = ('');#, '0_*2.exec');
my $sa	       = {};	my $sa_cpt	    = {};
my $ls          = {};   my $ls_cpt          = {};
my $OrOpt       = {};   my $OrOpt_cpt       = {};
my $twoOpt      = {};   my $twoOpt_cpt      = {};
my $Exchange    = {};   my $Exchange_cpt    = {};
my $SingleMove  = {};   my $SingleMove_cpt  = {};

foreach my $instance (@myInstances) {
    my @files = <$folder/*\/*$instance*.stats>;

    foreach my $file (@files) {
	my ($t0, $alpha, $instance, $exec) = $file =~
		    m/^$folder\/(\d\.*\d*)-(\d\.*\d*)\/(.*).exec(\d+).stats$/;
	open (FILEHANDLE, "<", $file)  or die "Could not open $file: $!";
	my $first = 1;
	foreach my $line (<FILEHANDLE> ) {
		if( $first ) {
		    $first = 0; # skip te first line
		}
		else {
		    my ($skip, $instance, $sa_, $ls_, $OrOpt_, $twoOpt_, $Exchange_, $SingleMove_) = split /\s+/, $line;
		    $sa->{$instance}	      += $sa_;		$sa_cpt->{$instance}	      += 1;
		    $ls->{$instance}          += $ls_;		$ls_cpt->{$instance}          += 1;
		    $OrOpt->{$instance}       += $OrOpt_;	$OrOpt_cpt->{$instance}       += 1;
		    $twoOpt->{$instance}      += $twoOpt_;	$twoOpt_cpt->{$instance}      += 1;
		    $Exchange->{$instance}    += $Exchange_;	$Exchange_cpt->{$instance}    += 1;
		    $SingleMove->{$instance}  += $SingleMove_;	$SingleMove_cpt->{$instance}  += 1;
		}
	}
	close FILEHANDLE;
    }
}
print sprintf("%-17.17s\t%-10.10s\t%-10.10s\t%-10.10s\t%-10.10s\t%-10.10s\t%-10.10s\n" ,
	       "instance", "sa" , "ls" , "OrOpt", "2Opt*", "Exchange", "SingleMove" );
foreach my $instance (keys %$sa){
    $sa->{$instance}	      /= $sa_cpt->{$instance};
    $ls->{$instance}          /= $ls_cpt->{$instance};
    $OrOpt->{$instance}       /= $OrOpt_cpt->{$instance};
    $twoOpt->{$instance}      /= $twoOpt_cpt->{$instance};
    $Exchange->{$instance}    /= $Exchange_cpt->{$instance};
    $SingleMove->{$instance}  /= $SingleMove_cpt->{$instance};
    print sprintf("%-17.17s\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\n" ,
		  $instance, $sa->{$instance} , $ls->{$instance} ,  $OrOpt->{$instance} , $twoOpt->{$instance}, $Exchange->{$instance}, $SingleMove->{$instance} );
}


