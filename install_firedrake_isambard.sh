#!/bin/bash

##################################################
# Script for installing Firedrake on Isambard    #
# Written by Jack Betteridge April 2020          #
# Updated August 2020                            #
#                                                #
# Currently this script works on a login node    #
# and uses an aprun wrapper (found in the same   #
# repository as this script). A build on an      #
# compute node will fail as nested aprun calls   #
# are forbidden                                  #
##################################################

module purge
module load PrgEnv-gnu
module load pmi-lib
module load cray-python/3.8.5.1
module load cray-mpich

# Load some Bristol modules
module use /projects/bristol/modules-arm/modulefiles
module load htop
module load valgrind

# Give the venv a name
export NEW_VENV_NAME=firedrake

# Dynamic linking
export CRAYPE_LINK_TYPE=dynamic
export MPICH_GNI_FORK_MODE=FULLCOPY

# Set all compilers to be Cray wrappers
export CC=cc
export CXX=CC
export F90=ftn
export F77=ftn

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
#~ export HDF5_DIR=$MAIN/$NEW_VENV_NAME/src/petsc/default
#~ export HDF5_MPI=ON
#~ export NETCDF4_DIR=$MAIN/$NEW_VENV_NAME/src/petsc/default

# Grab the Firedrake install script
curl -O https://raw.githubusercontent.com/firedrakeproject/firedrake/master/scripts/firedrake-install

# Add the following options to build PETSc
export PETSC_CONFIGURE_OPTIONS="--with-mpi-include=/opt/cray/pe/mpt/default/gni/mpich-gnu/8.1/include \
    --with-mpi-lib=/opt/cray/pe/mpt/default/gni/mpich-gnu/8.1/lib/libmpich.so \
    --with-x=0 --with-make-np=32 \
    --COPTFLAGS='-O3 -march=native -mtune=native' \
    --CXXOPTFLAGS='-O3 -march=native -mtune=native' \
    --FOPTFLAGS='-O3 -march=native -mtune=native' \
    --build=aarch64-linux-gnu"

# Massive hack
# There is currently a permissions bug when cloning the petsc4py repo
# this hacky bash loop fixes the permissions when the repo is cloned
# and allows the installation to complete
function hack {
    ls -j 2> /dev/null
    while [ $? -ne 0 ]
    do
        sleep 30s
        chmod -R ug+rw $MAIN/$NEW_VENV_NAME/src/petsc4py/.git 2> /dev/null
    done
    echo WOOP!
}
hack &

# For an intreractive session:
# qsub -I -q arm-dev -l walltime=03:00:00

# Install firedrake with the following options
python firedrake-install \
    --mpicc=cc \
    --mpicxx=CC \
    --mpif90=ftn \
    --mpiexec=$HOME/bin/aprun \
    --no-package-manager \
    --disable-ssh \
    --pip-install cppy \
    --pip-install kiwisolver \
    --pip-install $HOME/wheels/cffi/cffi-1.14.3-cp38-cp38-linux_aarch64.whl \
    --pip-install $HOME/wheels/vtk/vtk-9.0.1-cp38-cp38-linux_aarch64.whl \
    --pip-install $HOME/wheels/symengine.py/symengine-0.6.1-cp38-cp38-linux_aarch64.whl \
    --remove-build-files \
    --venv-name $NEW_VENV_NAME \
    --cache-dir $MAIN/.cache_$NEW_VENV_NAME

# Additional packages can be added to Firedrake upon a sucessful build
# using firedrake-update, see firedrake-update --help

# Now tarball the venv so that it can be used on compute nodes
mkdir -p $MAIN/.cache_$NEW_VENV_NAME
touch $MAIN/.cache_$NEW_VENV_NAME/foo
mkdir -p $HOME/bin
tar -czf $HOME/bin/$NEW_VENV_NAME.tar.gz $NEW_VENV_NAME
tar -czf $HOME/bin/cache_$NEW_VENV_NAME.tar.gz .cache_$NEW_VENV_NAME
