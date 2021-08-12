#!/bin/bash
#PBS -q arm
#PBS -l walltime=1:20:00
#PBS -l select=1
#PBS -N FD_build

cd ${PBS_O_WORKDIR}
bash install_firedrake_isambard.sh --install gusto
