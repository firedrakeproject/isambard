#!/bin/bash
#PBS -q arm
#PBS -l walltime=01:00:00
#PBS -l select=1
#PBS -N example_firedrake_job

# The script you want to run
myScript=script.py
# The number of processors to use
nprocs=64

# The following lines should not require modification #######

# Change to the directory that the job was submitted from
cd ${PBS_O_WORKDIR}

# Set the number of OpenMP threads to 1
# This prevents any system libraries from automatically
# using OpenMP threading. Unless you want this, in which
# case get rid of this line.
export OMP_NUM_THREADS=1

# Activate Firedrake venv
source $HOME/bin/firedrake_activate.sh

# Not sure what this line does...
# ...maybe magic?
export MPICH_GNI_FORK_MODE=FULLCOPY

# Run Firedrake script
aprun -b -n ${nprocs} python ${myScript}

