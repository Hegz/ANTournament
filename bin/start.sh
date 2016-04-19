#!/bin/bash
eval "$(perl -I../perl5/lib/perl5 -Mlocal::lib=../perl5)"
plackup -p 5000 app.psgi
