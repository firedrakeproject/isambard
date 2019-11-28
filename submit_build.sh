#!/bin/bash
#PBS -q arm
#PBS -l walltime=3:00:00
#PBS -l select=1
#PBS -N FD_build

cd ${PBS_O_WORKDIR}
./install_firedrake_isambard.sh
