#! /bin/bash

mkdir mdapioutput/

sfdx force:source:convert -d mdapioutput/

sfdx force:mdapi:deploy -d mdapioutput/ -u "EntArchPackaging" --wait 10 # wait until complete

rm -rf mdapioutput/