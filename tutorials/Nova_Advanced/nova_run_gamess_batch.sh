#!/bin/bash -x

#SBATCH -J YOURJOBNAME 
#SBATCH -o %x-%j.out
#SBATCH -t 0:10:00
#SBATCH -N 2
#SBATCH --ntasks-per-node=16
#SBATCH --partition=instruction
#SBATCH --account=f2026.chem.5800.02

export LMOD_SH_DBG_ON=1
export OMP_NUM_THREADS=1
export rpn=${SLURM_NTASKS_PER_NODE:-1}    # from --ntasks-per-node

## divide rpn tasks per node by 2 only if > 1 (ddi takes up 1 task per mpi rank for GAMESS calculation)
if [ $rpn -gt 1 ]; then
    rpn=$((rpn / 2))
fi


nnode=$SLURM_NNODES
ncpus=$((rpn * nnode))

module load cmake
module load openmpi 
module load openblas/0.3.30-ilp64-bqh5gp7

# srun refuses to start when both are set (e.g. inherited from the submitting shell)
if [ -n "$SLURM_MEM_PER_NODE" ] && [ -n "$SLURM_MEM_PER_CPU" ]; then
    unset SLURM_MEM_PER_CPU
fi

if [ $# -eq 0 ]; then
    echo "need at least one input"
    exit 1
fi
input=`realpath $1`
 echo $input

export LOG=${input%.inp}.log

cd $SLURM_SUBMIT_DIR

#CHANGE THIS TO YOUR PATH TO GAMESS
export GMSPATH=/lustre/hdd/LAS/mgordon-lab/jhayes1/source/gamess-current/gamess/

echo "Running on $nnode nodes"
echo "Running with $ncpus cpus"
echo "rpn $rpn"

#Make sure you have replaced rungms-dev with the nova version!!!!

$GMSPATH/rungms-dev $1 00 $ncpus $rpn &> $LOG 


