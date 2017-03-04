#!/bin/sh
cd ./test
/mnt/data/MATLAB/$MATLAB_VER/bin/./matlab -nodesktop -nosplash -r "launchTests;" < inputCI.txt;
CODE=$?
exit $CODE
