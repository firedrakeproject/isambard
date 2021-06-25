#!/bin/bash

set -eu

python_version_num=3.7.4
python_install_dir=${PWD}/python/${python_version_num}

echo "Setting up modules"
module swap PrgEnv-cray PrgEnv-gnu
module load tools/cmake
module list

echo "Setting PKG_CONFIG_PATH to pick up libffi"
export PKG_CONFIG_PATH=${python_install_dir}/lib/pkgconfig:${PKG_CONFIG_PATH}
echo

export PATH=${python_install_dir}/bin:${PATH}
export LD_LIBRARY_PATH=${python_install_dir}/lib:${LD_LIBRARY_PATH}
export LDFLAGS="-Wl,-rpath,${python_install_dir}/lib"

unset PYTHONPATH

# Set PETSc options
export PETSC_CONFIGURE_OPTIONS="-with-cc=cc -with-cxx=CC -with-mpiexec=aprun --download-hdf5 --download-hdf5-configure-arguments='-build=aarch64-unknown-linux-gnu'"

export MPIF90=ftn

# Allow dynamically linked executables to be built
export CRAYPE_LINK_TYPE=dynamic

# Set compiler for PyOP2
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
curl -O https://raw.githubusercontent.com/firedrakeproject/firedrake/isambardBuild/scripts/firedrake-install
echo "Installing"
python3 firedrake-install --verbose --no-package-manager --mpicc=cc --mpicxx=CC --mpif90=ftn --mpiexec=aprun $@

echo "Done"
