#!/usr/bin/perl 
# -*- coding: utf-8 -*-

use strict;
use warnings;

use Web::Scraper;
use URI;
use File::Spec qw/rel2abs/;

my $argv = shift;
search_files($argv);


sub search_files () {
    my $root_file = shift;
    my $fh;

    open $fh, '<', $root_file
        or die "Cannot open '$root_file': $!";

    my @html = <$fh>;

    close($fh);

    my $contents = join('', @html);

    my $res = scraper { process 'a', 'url[]' => '@href'; } -> scrape( $contents );

    if( defined($res->{url}) ){
        foreach my $u (@{$res->{url}}){
            if( -f $u ){
                search_files( File::Spec->rel2abs($u) );
            }
        }
    }
    else {
        print 'Non' . "\n";
    }
}


