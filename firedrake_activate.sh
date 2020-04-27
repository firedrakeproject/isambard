#!/bin/bash

##################################################
# Script for activating the Firedrake venv       #
# when installed using corresponding script      #
# Written by Jack Betteridge April 2020          #
#                                                #
##################################################

module swap PrgEnv-cray PrgEnv-gnu/6.0.5
module load pmi-lib
module load cray-python/3.6.5.6

# Load some Bristol modules
module use /projects/bristol/modules-arm/modulefiles
module load htop
module load valgrind/3.13.0

# Set main to be working directory
export MAIN=/home/ba-jbetteridge/firedrake_fix/
# Include the name of the venv
export VENV_NAME=new_script # Or wahtever you named the venv

# Dynamic linking
export CRAYPE_LINK_TYPE=dynamic

# Set all compilers to be Cray wrappers
export CC=cc
export CXX=CC
export F90=ftn

export MPICC=cc
export MPICXX=CC
export MPIF90=ftn

# Needed for numpy and scipy
export LAPACK=/opt/cray/pe/libsci/18.12.1/gnu/8.1/aarch64/lib/libsci_gnu_82.so
export BLAS=/opt/cray/pe/libsci/18.12.1/gnu/8.1/aarch64/lib/libsci_gnu_82.so
# PYTHONPATH is set by Cray python and not helpful here!
unset PYTHONPATH

# hdf5/h5py/netcdf variables set as they were for installation
export HDF5_DIR=$MAIN/$VENV_NAME/src/petsc/default
export HDF5_MPI=ON
export NETCDF4_DIR=$MAIN/$VENV_NAME/src/petsc/default

# Set the PyOP2 compiler to the Cray wrapper
# This currently requires a branch of PyOP2 to work correctly
export PYOP2_BACKEND_COMPILER=cc

source $MAIN/$VENV_NAME/bin/activate