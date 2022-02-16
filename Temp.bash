#!/bin/bash

ASDF="it didn't work"

ASDF=`python <<END
ASDF = 'it worked'
print ASDF
END`

echo $ASDF
