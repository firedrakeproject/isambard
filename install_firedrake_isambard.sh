#!/bin/bash

set -eu

echo "Setting up modules"
module swap PrgEnv-cray PrgEnv-gnu
module load tools/cmake
module load cray-python
module load cray-hdf5-parallel

# Unset the python path otherwise the Firedrake install script won't run
unset PYTHONPATH

# Set PETSc options
export PETSC_CONFIGURE_OPTIONS="-with-cc=cc -with-cxx=CC -with-mpiexec=aprun --with-hdf5-dir=${HDF5_DIR}"

# Set all compilers to Cray wrappers for consistency
export CC=cc
export CXX=CC
export F90=ftn

export MPICC=cc
export MPICXX=CC
export MPIF90=ftn

# Don't build in /tmp as this is not shared between nodes
export TMPDIR=${HOME}/tmp
if [[ -d ${TMPDIR} ]]; then
    echo "Found ${TMPDIR}"
else
    echo "Making ${TMPDIR}"
    mkdir ${TMPDIR}
fi

echo "Fetching install script"
curl -O https://raw.githubusercontent.com/firedrakeproject/firedrake/master/scripts/firedrake-install

echo "Installing"
vtk_wheel="https://github.com/firedrakeproject/VTKPythonPackage/releases/download/firedrake_20210613/vtk-9.0.1-cp38-cp38-linux_aarch64.whl"
netcdf_wheel="/projects/exeter/firedrake/wheels/netCDF4-1.5.7-cp38-cp38-linux_aarch64.whl"
python3 firedrake-install --verbose --no-package-manager --mpicc=cc --mpicxx=CC --mpif90=ftn --mpiexec=aprun --pip-install ${vtk_wheel} --pip-install ${netcdf_wheel} $@

echo "Done"
