#!/bin/bash

##################################################
# Script for updating Firedrake tarball on       #
# Isambard                                       #
# Written by Jack Betteridge August 2020         #
#                                                #
##################################################

# MAIN should be /tmp/$USER
cd $MAIN
mv $HOME/bin/firedrake.tar.gz $HOME/bin/firedrake.tar.gz.bck
tar -czvf $HOME/bin/firedrake.tar.gz $VENV_NAME
