#!/bin/bash

##################################################
# Script for updating Firedrake tarball on       #
# Isambard                                       #
# Written by Jack Betteridge August 2020         #
#                                                #
##################################################

# MAIN should be /tmp/$USER
cd $MAIN
mv $HOME/bin/$VENV_NAME.tar.gz $HOME/bin/$VENV_NAME.tar.gz.bck
tar -czvf $HOME/bin/$VENV_NAME.tar.gz $VENV_NAME
