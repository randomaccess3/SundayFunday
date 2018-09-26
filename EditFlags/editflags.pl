#-----------------------------------------------------------
package editflags;
#-----------------------------------------------------------
# 
# Plugin to extract the EditFlags value/data
# Based on clsid.pl 

#
# History
#   20180629 - initial commit

use strict;

my %config = (hive          => "Software",
              osmask        => 22,
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              version       => 20180629);

sub getConfig{return %config}

sub getShortDescr {
	return "Get list of CLSID/registered classes";	
}
sub getDescr{}
sub getRefs {}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
	my $class = shift;
	my $hive = shift;
	
	my %clsid;
	::logMsg("Launching editflags v.".$VERSION);
	::rptMsg("editflags v.".$VERSION); # banner
	::rptMsg("(".$config{hive}.") ".getShortDescr()."\n"); # banner
	my $reg = Parse::Win32Registry->new($hive);
	my $root_key = $reg->get_root_key;

	#	my $key_path = "Classes\\CLSID";
	my @paths = ("Classes", "Classes\\CLSID","Classes\\Wow6432Node\\CLSID");
	foreach my $key_path (@paths) {
		my $key;
		if ($key = $root_key->get_subkey($key_path)) {
			::rptMsg($key_path);
			::rptMsg("");

			my @sk = $key->get_list_of_subkeys();
			if (scalar(@sk) > 0) {
				foreach my $s (@sk) {
					my $name = $s->get_name();
					my @vals = $s->get_list_of_values();
					if (scalar(@vals) > 0) {
						foreach my $v (@vals) {
							my $valueName = $v->get_name();
							if ($valueName eq "EditFlags"){
								my $data = $v->get_data();
								$data = unpack("V",$data);
								my $hex = sprintf("%X", $data);
								::rptMsg($name . " : ". $hex);
							}
						}

					}
				}
			}
			else {
				::rptMsg($key_path." has no subkeys.");
			}
		}
		else {
			::rptMsg($key_path." not found.");
		}
	}
}


1;