#!/bin/bash

##################################################
# Script for updating Firedrake cache tarball on #
# Isambard                                       #
# Written by Jack Betteridge September 2020      #
#                                                #
##################################################

# MAIN should be /tmp/$USER
cd $MAIN
tar -czvf $HOME/bin/cache_$VENV_NAME.tar.gz .cache_$VENV_NAME
