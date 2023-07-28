#!/bin/bash
#PBS -q arm
#PBS -l walltime=01:00:00
#PBS -l select=1
#PBS -N example_firedrake_job

# The script you want to run
myScript=script.py
# The number of processors to use
nodes=1
nprocs=64

# The following lines should not require modification #######

# Change to the directory that the job was submitted from
cd ${PBS_O_WORKDIR}

# Set the number of OpenMP threads to 1
# This prevents any system libraries from automatically
# using OpenMP threading. Unless you want this, in which
# case get rid of this line.
export OMP_NUM_THREADS=1

# Activate Firedrake venv (activate once on mom node, extract once per node)
source $HOME/bin/fdactivate
aprun -b -n ${nodes} -N 1 $HOME/bin/fdactivate

# Jack said I need this hack:
export LD_PRELOAD=/opt/cray/pe/gcc-libs/libgomp.so.1

# Run Firedrake script
aprun -b -n ${nprocs} python ${myScript}

# Update tarball with compiled code cache
aprun -b -n 1 $HOME/bin/updatefdcache
