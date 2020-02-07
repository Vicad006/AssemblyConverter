#!/usr/bin/perl

	######################################################################################################
	#												  ####
	# ABOUT: Perl Script to map Assembly Coordinates from one version to another			  ####
	#												  ####
	# DEPENDENCIES: PERL5LIB and Ensembl Perl APIs 							  ####
	#												  ####
	# INSTALLLING ENSEMBL PERL API Guide: http://www.ensembl.org/info/docs/api/api_installation.html  ####
	#												  ####
	# ANGULAR APP OF THIS ASSEMBLY CONVERSION TOOL CAN BE ACCESSED AT: ...				  ####
	#												  ####
	# PROGRAM WRITTEN BY OLUWASEUN VICTORIA MOSAKU							  ####
	#												  ####
	######################################################################################################

use strict;
use warnings;

# Set present working directory so that SliceObject.pm can be loaded
use lib "$ENV{'PWD'}";

# import file reader library
use IO::File;

# import GetOption Library to process user specified commandline options
use Getopt::Long;

# import Ensembl registry
use Bio::EnsEMBL::Registry;

# import the SliceObject class 
use SliceObject;

# define and intialize variables
my ($filename, $specie);
my $help = '';
my $mappedVersion = 'GRCh37';

my $registry = 'Bio::EnsEMBL::Registry';
my $host = 'ensembldb.ensembl.org';
my $port = 3306;
my $user = 'anonymous';

# create an instance of the SliceObject class to hold data
my $mySlice = new SliceObject();

# Retrieve user inputs via the command line
GetOptions( 'file|f=s' => \$filename, 'specie|s=s' => \$specie, 'version|v=s' => \$mappedVersion, 'help|h!' => \$help );

# if inputs are not valid, display help information for the user
if ( !GetOptions( 'file|f=s' => \$filename, 'specie|s=s' => \$specie, 'help|h!' => \$help )
     || !( defined($filename) && defined($specie) && defined($mappedVersion) )
     || $help )
{
   $mySlice->displayHelp($0);
   exit(1);
}

# Load Ensembl registry
$registry->load_registry_from_db(
	-host => $host,
	-port => $port,
	-user => $user 
);

my $slice_adaptor = $registry->get_adaptor($specie, 'Core', 'Slice' );

# Read the user file containing data to be mapped
my $in = IO::File->new($filename);

# Ensure that file data was successfully read
if ( !defined($in) ) {
  die( sprintf( "Could not open file '%s' for reading", $filename ) );
}


while ( my $line = $in->getline() ) {

  $mySlice->validateAndGetCoordinates($line);

  if ($mySlice->getCsName) {
  } else {
    printf( "Malformed line:\n%s\n", $line );	next;
  }

  # Get a slice for the old region (the region in the input file).
  my $original_slice =  $slice_adaptor->fetch_by_region(
						$mySlice->getCsName, 
						$mySlice->getSrName, 
						$mySlice->getStart, 
						$mySlice->getEnd,
						$mySlice->getStrand,  
						$mySlice->getVersion );


  printf( "# %s\n\n", $original_slice->name() );

  # Update any missing co-ordinate data.
  $mySlice->setCsName($original_slice->coord_system_name());
  $mySlice->setSrName($original_slice->seq_region_name());
  $mySlice->setStart($original_slice->start());
  $mySlice->setEnd($original_slice->end());
  $mySlice->setStrand($original_slice->strand());
  $mySlice->setVersion($original_slice->coord_system()->version());

  # Project the old slice to the current assembly and display information about each resulting segment.GRCh38
  foreach my $segment ( @{ $original_slice->project('chromosome', $mappedVersion) } ) {

    # We display the old slice info followed by a comma and then the new slice (segment) info.
    printf( "%s:%s:%s:%d:%d:%d --> %s\n",
            $mySlice->getCsName,
            $mySlice->getVersion,
            $mySlice->getSrName,
            $mySlice->getStart + $segment->from_start() - 1,
            $mySlice->getStart + $segment->from_end() - 1,
            $mySlice->getStrand,
            $segment->to_Slice()->name() );
  }

  print("\n");

}



