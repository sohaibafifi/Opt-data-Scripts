#!/usr/bin/perl -w

use strict;
use warnings;
use Getopt::Long;
use List::Util qw/min max sum/;
use Data::Dumper ;
my $folder = 'output';
my $length = @ARGV;
if($length eq 1){
    $folder = $ARGV[0];
}

my @myInstances = ('');
my $gaps = {} ; my $times = {} ;  my $objs = {} ;
foreach my $instance (@myInstances) {
    my @files = <$folder/*\/*$instance*.result>;
    foreach my $file (@files) {
	my ($t0, $alpha, $instance, $exec) = $file =~
		    m/^$folder\/(\d\.*\d*)-(\d\.*\d*)\/(.*).exec(\d+).result$/;
	open (FILEHANDLE, "<", $file)  or die "Could not open $file: $!";
	foreach my $line (<FILEHANDLE> ) {
	    my ($instance, $td, $gap, $time, $seed) = split /\s*:\s*/, $line;
	    $objs->{$instance}{"$seed-$t0-$alpha"} = $td;
	    $gaps->{$instance}{"$seed-$t0-$alpha"} = $gap;
	    $times->{$instance}{"$seed-$t0-$alpha"} = $time;
	}
	close FILEHANDLE;
    }
}
#header
print sprintf("%-17.17s\t%-10.5s\t%-10.5s\t%-10.5s\n" ,
	       "instance", "obj" , "cpu" , "gap" );
foreach my $instance (sort {$a cmp $b} keys %$objs){
    my ($min) = min (values %{$objs->{$instance}});
    my $mintime = 999999;
    while( my ($key, $value) = each %{$objs->{$instance} }){
	my $time = $times->{$instance}{$key};
	if($value == $min && $time < $mintime){
	    $mintime = $time;
	}
    }
    my $mingap = 999999;
    while( my ($key, $value) = each %{$objs->{$instance} }){
	my $gap = $gaps->{$instance}{$key};
	if($value == $min && $gap < $mingap){
	    $mingap = $gap;
	}
    }
    print sprintf("%-17.17s\t%10.3f\t%10.3f\t%10.3f\n" ,
		  $instance, $min , $mintime , $mingap );
}
