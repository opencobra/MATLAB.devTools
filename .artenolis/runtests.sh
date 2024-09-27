#!/bin/sh
cd ./test
$ARTENOLIS_SOFT_PATH/MATLAB/$MATLAB_VER/bin/./matlab -nodesktop -nosplash -r "launchTests;" < inputCI.txt;
CODE=$?
exit $CODE
