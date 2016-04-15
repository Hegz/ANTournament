#!/bin/bash
eval "$(perl -Iperl5/lib/perl5 -Mlocal::lib=perl5)"
plackup -p 5000 bin/app.psgi
