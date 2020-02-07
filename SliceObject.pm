#!/usr/bin/perl 

package SliceObject;

# A perl class for holding and manipulating splice coordinates
sub new {

   my $class = shift;
   my $self = {
      _csName 	=> null,
      _version  => null,
      _srName   => null,
      _start   => null,
      _end   => null,
      _strand   => null,
   };

   bless $self, $class;
   return $self;
}


# setters set variable values
sub setCsName {
   my ( $self, $csName ) = @_;
   $self->{_csName} = $csName if defined($csName);
   return $self->{_csName};
}

sub setVersion {
   my ( $self, $version ) = @_;
   $self->{_version} = $version if defined($version);
   return $self->{_version};
}

sub setSrName {
   my ( $self, $srName ) = @_;
   $self->{_srName} = $srName if defined($srName);
   return $self->{_srName};
}

sub setStart {
   my ( $self, $start ) = @_;
   $self->{_start} = $start if defined($start);
   return $self->{_start};
}

sub setEnd {
   my ( $self, $end ) = @_;
   $self->{_end} = $end if defined($end);
   return $self->{_end};
}

sub setStrand {
   my ( $self, $strand ) = @_;
   $self->{_strand} = $strand if defined($strand);
   return $self->{_strand};
}


# getters to retrieve variable values
sub getCsName {
   my( $self ) = @_;
   return $self->{_csName};
}

sub getVersion {
   my( $self ) = @_;
   return $self->{_version};
}

sub getSrName {
   my( $self ) = @_;
   return $self->{_srName};
}

sub getStart {
   my( $self ) = @_;
   return $self->{_start};
}

sub getEnd {
   my( $self ) = @_;
   return $self->{_end};
}

sub getStrand {
   my( $self ) = @_;
   return $self->{_strand};
}



# This is used to validate and retrieve Slice Object submitted by user
sub validateAndGetCoordinates {

   my ( $self, $line ) = @_;

   chomp($line);

  # Check location string is correctly formatted
  my $number_seps_regex = qr/\s+|,/;
  my $separator_regex = qr/(?:-|[.]{2}|\:|_)?/;
  my $number_regex = qr/[0-9, E]+/xms;
  my $strand_regex = qr/[+-1]|-1/xms;


  # Location string should look like chromosome:GRCh37:X:1000000:1000100:1
  # Strand, start and end can be left out
  my $regex = qr/^(\w+) $separator_regex (\w+) $separator_regex ((?:\w|\.|_|-)+) \s* :? \s* ($number_regex)? $separator_regex ($number_regex)? $separator_regex ($strand_regex)? $/xms;


  if ( ($self->{_csName}, $self->{_version}, $self->{_srName}, $self->{_start}, $self->{_end}, $self->{_strand}) = $line =~ $regex) {
	
  } else {
    printf( "Malformed line:\n%s\n", $line );
  }

   return $self;
}




# This is used to display help information 
sub displayHelp {

   my ( $self, $mappingFile ) = @_;

  print <<END_USAGE;
Usage:
  $mappingFile -specie=specie -file=filename -version=AssemblyVersionToMapTo
  $mappingFile --help
    --specie / -s   Name of specie.
    --file   / -f   Name of file containing a list of slices to map
    --version/ -v   Assembly Version you desire to map your file contents to
		    This is optional as it defaults to GRCh37 when nothing is specified.  
		
		    The data format is the same as the output of the name() method on a
                    Slice object: coord_system:version:seq_region_name:start:end:strand
                    For example: chromosome:chromosome:GRCh38:10:25000:30000:1

                    Note: Mappings are available for chromosomes to any valid assembly 
		    version, either from old assemblies to the latest assembly, or between 
		    old assemblies or from the latest assembly.
                    If the strand is missing, the positive ("1") strand will be used.
                    If the start is missing, it is taken to be "1".  If the end is missing, 
		    it is taken to be the end of the seq_region.
    --help    / -h  To see this text.
Example usage:
  $mappingFile -s human -f data_to_map.txt -v GRCh37
END_USAGE

}
1;
