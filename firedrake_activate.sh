#!/bin/bash

##################################################
# Script for activating the Firedrake venv       #
# when installed using corresponding script      #
# Written by Jack Betteridge April 2020          #
#                                                #
##################################################

module purge
module load PrgEnv-gnu
module load pmi-lib
module load cray-python/3.8.2.1
module load cray-mpich

# Load some Bristol modules
module use /projects/bristol/modules-arm/modulefiles
module load htop
module load valgrind

# Give the venv a name
export VENV_NAME=firedrake  # Or whatever you named the venv

# Dynamic linking
export CRAYPE_LINK_TYPE=dynamic
export MPICH_GNI_FORK_MODE=FULLCOPY

# Set all compilers to be Cray wrappers
export CC=cc
export CXX=CC
export F90=ftn

export MPICC=cc
export MPICXX=CC
export MPIF90=ftn

# Needed for numpy and scipy
export LAPACK=/opt/cray/pe/libsci/default/gnu/8.1/aarch64/lib/libsci_gnu.so
export BLAS=/opt/cray/pe/libsci/default/gnu/8.1/aarch64/lib/libsci_gnu.so
# PYTHONPATH is set by Cray python and not helpful here!
unset PYTHONPATH

# Set main to be working directory
# Create this in /tmp so we don't have issues with the lustre filesystem
mkdir -p /tmp/$USER
cd /tmp/$USER
MAIN=`pwd`
# hdf5/h5py/netcdf difficult to install, help as much as possible
# by providing these paths
export HDF5_DIR=$MAIN/$VENV_NAME/src/petsc/default
export HDF5_MPI=ON
export NETCDF4_DIR=$MAIN/$VENV_NAME/src/petsc/default

# Set the PyOP2 compiler to the Cray wrapper
# This currently requires a branch of PyOP2 to work correctly
export PYOP2_BACKEND_COMPILER=cc

mkdir -p /tmp/$USER
tar -xzf $HOME/bin/$VENV_NAME.tar.gz -C /tmp/$USER

source $MAIN/$VENV_NAME/bin/activate
