#!/usr/bin/env perl
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

package license;

use 5.006;
use strict;
use warnings;
use autodie;
use utf8;
use threads;

use Carp;
use Exporter qw(import);
use File::Basename;
use LWP::UserAgent ();
use HTML::TokeParser;

our @EXPORT    = qw();
our @EXPORT_OK = qw();

our $VERSION = '0.0.1';

sub get_stream_from_url {
    my $url = shift;

    croak "URL is undefined." unless defined $url;

    my $ua = LWP::UserAgent->new;
    my $r  = $ua->get($url);
    return unless $r->is_success;
    return HTML::TokeParser->new( \( $r->decoded_content ) );
}

sub download_license {
    my ( $l, $u ) = @_;

    croak "License name or license URL is undefined"
        unless defined $l and defined $u;

    print "Downloading license: $l\n";
    my $s = get_stream_from_url($u) or die "Failed to download $l";
    my $t = $s->get_tag('pre');

    open my $lic, '>:encoding(utf8)', $l or die "Can not open $l";
    print $lic $s->get_text . "\n";
    close $lic;
}

sub main {
    my $argc = @_;
    my @argv = @_;
    my $jobs = $argv[0] || 8;
    my $suffix = $argv[1] || '.txt';

    binmode STDIN,  ':encoding(utf8)';
    binmode STDOUT, ':encoding(utf8)';
    binmode STDERR, ':encoding(utf8)';

    my %license_urls;
    my $home_url     = 'https://choosealicense.com';
    my $appendix_url = $home_url . '/appendix/';

    my $s = get_stream_from_url($appendix_url)
        or die "Can not get appendix from $appendix_url";

    while ( my $t = $s->get_tag('th') ) {
        next unless $t->[1]->{scope} eq 'row';
        $t = $s->get_tag('a') or next;
        $license_urls{ basename $t->[1]->{href} }
            = $home_url . $t->[1]->{href} . '/';
    }

    for my $l ( keys %license_urls ) {
        threads->create( \&download_license, $l . $suffix, $license_urls{$l} );
        while ( threads->list(threads::running) >= $jobs ) {
            $_->join() for threads->list(threads::joinable);
        }
    }

    while ( threads->list(threads::all) ) {
        $_->join() for threads->list(threads::joinable);
    }

    return 0;
}

main(@ARGV) unless caller(0);

# vim:set ft=perl ts=4 sw=4:
