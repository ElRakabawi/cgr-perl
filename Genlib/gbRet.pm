#!/usr/bin/perl

# Author: Muhammed S. ElRakabawi (elrakabawi.github.io)
# gbRet is a GenBank retrieval module for Gentein Translator
package Genlib::gbRet;

use warnings;
use strict; 
use Bio::DB::GenBank;
use Bio::SeqIO;  
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;
my $gbank = new Bio::DB::GenBank;

sub retrieve {
	my $accNo = $_[1];
	my $seq1 = $gbank -> get_Seq_by_acc($accNo);
	my $sequence = $seq1 -> seq;

	for my $feat ($seq1 -> get_SeqFeatures){
	  if ($feat -> primary_tag eq 'CDS'){ # Checking for CDS info
	    return $sequence;
	  }
	}
}