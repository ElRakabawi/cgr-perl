#!/usr/bin/perl -w
use strict;
use warnings;

use Genlib::gbRet; #GenBank retrieval module

my $arg = $ARGV[0];                        # Returns the first argument (Either -r for retrieve or -f for file)
my $dist = $ARGV[1];                       # Returns the first argument value (file.fasta or GenBank Accession number)
my $kArg = $ARGV[2];					   # Returns the second argument (-k for k-mer length)
my $kmer = $ARGV[3];                       # Returns the second argument value (int)
my $sequence = ();                         # This sequence variable stores the sequences from the .fasta file
my $wholeSeq;
my $KMER_SIZE = $kmer;

sub kmers {
    my $seq = shift or return;
    my $len = length $seq;

    my @kmers;
    for (my $i = 0; ($i + $KMER_SIZE) <= $len; $i++) {
    	my $kmer = substr($seq, $i, $KMER_SIZE);
    	print "$kmer\n";
        push @kmers, substr($seq, $i, $KMER_SIZE);
    }

    return \@kmers;
 }

if($arg eq "-f"){
	my $infile = $dist;                    # This is the file path
	open INFILE, $infile or die "Can't open $infile: $!";        # This opens file, but if file isn't there it mentions this will not open
	my $outfile = "SeqOutput.txt";         # This is the file's output
	open OUTFILE, ">$outfile";             # This opens the output file                

	my $line;                              # This reads the input file one-line-at-a-time

	while ($line = <INFILE>) {
	    chomp $line;                       # This removes "\n" at the end of each line (this is invisible)

	    if($line =~ /^\s*$/) {             # This finds lines with whitespaces from the beginning to the ending of the sequence. Removes blank line.
	        next;

	    } elsif($line =~ /^\s*#/) {        # This finds lines with spaces before the hash character. Removes .fasta comment
	        next; 
	    } elsif($line =~ /^>/) {           # This finds lines with the '>' symbol at beginning of label. Removes .fasta label
	        next;
	    } else {
	        $sequence = $line;
	    }

	    $sequence =~ s/\s//g;              # Whitespace characters are removed
	    print OUTFILE $sequence;

	    $wholeSeq .= $sequence;
	}
}
elsif($arg eq "-r"){
	print "Retrieving Sequence of $dist from GenBank..\n";
	chomp $dist;
	my $outfile = "$dist.txt";             # Output the file with (ACCESSION NO.txt)
	open OUTFILE, ">$outfile";             # This opens the output file

	$sequence = Genlib::gbRet->retrieve($dist);

	print "Sequence successfully retrieved and saved in $dist.txt\n";
	$sequence =~ s/\s//g;                  # Whitespace characters are removed
	print OUTFILE $sequence;               # Prints pure sequence to the output file
}

kmers($wholeSeq);
