#!/bin/bash
#PBS -q arm
#PBS -l walltime=00:30:00
#PBS -l select=1
#PBS -N Gusto_tests

# The directory which contains your firedrake installation
my_firedrake=${HOME}/firedrake/
my_gusto=${my_firedrake}/firedrake/src/gusto

# Change to the Gusto directory
cd ${my_gusto}

# Set the number of threads to 1
# This prevents any system libraries from automatically 
# using threading.
export OMP_NUM_THREADS=1

module swap PrgEnv-cray PrgEnv-gnu

export LD_LIBRARY_PATH=${my_firedrake}/python/3.7.4/lib:${LD_LIBRARY_PATH}
export PATH=${my_firedrake}/python/3.7.4/bin:${PATH}

# Allow dynamically linked executables to be built
export CRAYPE_LINK_TYPE=dynamic

# Set compiler for PyOP2
export CC=cc
export CXX=CC

echo "Activating Firedrake virtual environment"
. ${my_firedrake}/firedrake/bin/activate

export MPICH_GNI_FORK_MODE=FULLCOPY

# Run Firedrake
aprun -b -n 1 make test

echo "All done"

# End of file ################################################################

