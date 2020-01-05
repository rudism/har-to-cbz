#!/usr/bin/env perl

use strict;
use warnings;

use File::Path qw(rmtree);
use IO::Compress::Zip qw(zip $ZipError);
use JSON::SL;
use MIME::Base64 qw(decode_base64);

if(-e 'cbz' || !(mkdir 'cbz')) {
  die 'could not create output dir cbz';
}

my $p = JSON::SL->new;
$p->set_jsonpointer(['/log/entries/^']);

my %files = ();
local $/ = \5;
while(my $buf = <>) {
  $p->feed($buf);
  while(my $obj = $p->fetch) {
    my $req = $obj->{Value}{request}{url};
    if($req =~ /^.*\/([^\d]*)(\d+)([^\d]*)\.jpg(\?|#|$)/i) {
      my $fname = $1 . sprintf('%05d', $2) . "$3.jpg";
      my $data = decode_base64($obj->{Value}{response}{content}{text});
      if(!exists $files{$fname} || length($data) > $files{$fname}) {
        $files{$fname} = length($data);
        print "Saving $fname...\n";
        open(my $img, '>', "cbz/$fname") or die $!;
        print $img $data;
        close($img);
      }
    }
  }
}

my @fnames = keys %files;
my $count = scalar(@fnames);
print "Zipping $count files into comic.cbz...\n";
chdir 'cbz';
zip \@fnames => '../comic.cbz' or die $ZipError;

chdir '..';
rmtree('cbz');
print "Done.\n";
