#!/bin/bash

set -eu

echo "Setting up modules"
module swap PrgEnv-cray PrgEnv-gnu
module load tools/cmake
module load cray-python
module list

unset PYTHONPATH

# Set PETSc options
export PETSC_CONFIGURE_OPTIONS="-with-cc=cc -with-cxx=CC -with-mpiexec=aprun --download-hdf5 --download-hdf5-configure-arguments='-build=aarch64-unknown-linux-gnu'"

# Set compilers
export MPIF90=ftn
export CC=cc

# Don't build in /tmp as this is not shared between nodes
export TMPDIR=${HOME}/tmp
if [[ -d ${TMPDIR} ]]; then
    echo "Found ${TMPDIR}"
else
    echo "Making ${TMPDIR}"
    mkdir ${TMPDIR}
fi

echo "Fetching install script"
#curl -O https://raw.githubusercontent.com/firedrakeproject/firedrake/isambardBuild/scripts/firedrake-install
cp /home/ex-dmacreman/firedrake_branch/firedrake/scripts/firedrake-install .
echo "Installing"
python3 firedrake-install --verbose --no-package-manager --mpicc=cc --mpicxx=CC --mpif90=ftn --mpiexec=aprun $@

echo "Done"
