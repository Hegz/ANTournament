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
	$TMPDIR=$(mktemp -d)
	$INSTDIR=$(pwd)
	cd $TMPDIR
	wget http://search.cpan.org/CPAN/authors/id/H/HA/HAARG/local-lib-2.000018.tar.gz
	tar -xzf local-lib-2.000018.tar.gz
	cd local-lib-2.000018
	perl Makefile.PL --bootstrap=$INSTDIR/perl5
	make test && make install

	# Cleanup the lib::local install
	cd ..
	rm -rf local-lib-2.000018
	rm local-lib-2.000018.tar.gz
	cd $INSTDIR
	rmdir $TEMPDIR
fi

# Setup lib::local for use
eval "$(perl -Iperl5/lib/perl5 -Mlocal::lib=perl5)"

# intall the modules from cpan
cpan Dancer2 Template File::Slurper DBD::SQLite

# Install bootstrap
if [ ! -e public/css/bootstrap.min.css ]
then
	echo Installing bootstrap
	$TMPDIR=$(mktemp -d)
	$INSTDIR=$(pwd)
	cd $TMPDIR

	wget https://github.com/twbs/bootstrap/releases/download/v3.3.6/bootstrap-3.3.6-dist.zip
	unzip bootstrap-3.3.6-dist.zip
	cp -R bootstrap-3.3.6-dist/fonts $INSTDIR/public/
	cp bootstrap-3.3.6-dist/css/bootstrap.min.css bootstrap-3.3.6-dist/css/bootstrap.min.css.map $INSTDIR/public/css
	cp -R bootstrap-3.3.6-dist/js/bootstrap.min.js $INSTDIR/public/javascripts
	rm -rf bootstrap-3.3.6-dist bootstrap-3.3.6-dist.zip
	cd $INSTDIR
	rm $TEMPDIR
fi

# Install Jquery
if [ ! -e public/javascripts/jquery.min.js ]
then
	echo Installing jquery
	wget https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js -O public/javascripts/jquery.min.js
fi
