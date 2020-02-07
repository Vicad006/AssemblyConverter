
Summary
----------------------------------------------------------------------------------------
A Perl Script that uses Ensembl API to map Assembly Coordinates from one version to another


Dependencies:
----------------------------------------------------------------------------------------
1.) Ensure you have PERL5LIB installed
2.) You must have Ensembl Perl API installed on the machine, you can install Ensembl API using any of the 3 options below:
	i.) Instructions on installing Ensembl API can be found here: http://www.ensembl.org/info/docs/api/api_installation.html
	ii.) Video tutorial on how to install the Ensembl API can be found here: https://www.youtube.com/watch?v=nxTFcKi1nDw. 
	iii.) Commands to install Ensembl API : ftp://ftp.ebi.ac.uk/pub/databases/ensembl/Helpdesk/API_GIT_video_script.txt 


Example usage: An example input file (data_to_map.txt) is provided with this script.
----------------------------------------------------------------------------------------
1.) ./AssemblyConverter.pl -s human -f data_to_map.txt -v GRCh37
2.) ./AssemblyConverter.pl -s human -f data_to_map.txt

When either of this is run, the output should be:

chromosome:GRCh38:10:25000:30000:1 --> chromosome:GRCh37:HG905_PATCH:75000:80000:1
chromosome:GRCh38:10:25000:25845:1 --> chromosome:GRCh37:10:70936:71781:1
chromosome:GRCh38:10:25846:26246:1 --> chromosome:GRCh37:10:71784:72184:1
chromosome:GRCh38:10:26249:27608:1 --> chromosome:GRCh37:10:72185:73544:1
chromosome:GRCh38:10:27609:30000:1 --> chromosome:GRCh37:10:73546:75937:1


Description of Command Options:
----------------------------------------------------------------------------------------
-s or -specie 	: This is the Name of specie e.g human
-f or -file 	: This is the name of file containing a list of slices to map
-v or -version  : This is the Assembly Version you desire to map your file contents to. This is optional, it has default value of GRCh37

  ./AssemblyConverter.pl -specie=specie -file=filename -version=AssemblyVersionToMapTo 
  ./AssemblyConverter.pl --help

The expected data format is the same as the output of the name() method on a Slice object: coord_system:version:seq_region_name:start:end:strand
For example: chromosome:GRCh38:10:25000:30000:1

Mappings are available for chromosomes to any valid assembly version, either from old assemblies to the latest assembly, or betweenold assemblies or from the latest assembly.
If the strand is missing, the positive ("1") strand will be used. If the start is missing, it is taken to be "1".  If the end is missing, it is taken to be the end of the seq_region.




Help on How to Run:
----------------------------------------------------------------------------------------
For a summary of command line options, run the command inside the directory this program:

  ./AssemblyConverter.pl -help

Usage:
  ./AssemblyConverter.pl -specie=specie -file=filename -version=Assembly version to map to 
  ./AssemblyConverter.pl --help
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
  ./AssemblyConverter.pl -s human -f data_to_map.txt -v GRCh37Usage

