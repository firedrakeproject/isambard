#!/bin/bash
#PBS -q arm
#PBS -l walltime=01:00:00
#PBS -l select=1
#PBS -N FD_test

# The directory which contains your firedrake installation
my_firedrake=${HOME}/firedrake
# The script you want to run
myScript=script.py
# The number of processors to use
nprocs=64

# The following lines should not require modification #######

# Change to the directory that the job was submitted from
cd ${PBS_O_WORKDIR}

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
aprun -b -n ${nprocs} python ${myScript}

echo "All done"

# End of file ################################################################

