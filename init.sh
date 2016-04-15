#/bin/bash
# Dancer 2 initilization/update script

#Check if lib::local is installed
if [ ! -e perl5/lib/perl5/local/lib.pm ]
then
	echo 'This script will install perl lib::Local to ./perl5 as well as the'
	echo 'following modules:'
	echo 'Dancer2'
	echo 'Template'
	echo 'File::Slurper'
	echo 'DBD::SQLite'
	echo ''
	echo 'This script can also be used after install to upgrade the modules'
	echo 'needed for this project'
	echo '' 
	read -rsp $'Press any key to continue, or CTRL+C to cancel.\n' -n1 key

	# Download and install lib::Local to the ./perl5 directory
	wget http://search.cpan.org/CPAN/authors/id/H/HA/HAARG/local-lib-2.000018.tar.gz
	tar -xzf local-lib-2.000018.tar.gz
	cd local-lib-2.000018
	perl Makefile.PL --bootstrap=../perl5
	make test && make install

	# Cleanup the lib::local install
	cd ..
	rm -rf local-lib-2.000018
	rm local-lib-2.000018.tar.gz
fi

# Setup lib::local for use
eval "$(perl -Iperl5/lib/perl5 -Mlocal::lib=perl5)"

# intall the modules from cpan
cpan Dancer2 Template File::Slurper DBD::SQLite
