# allocate a compute node to do the build and a basic test
# salloc -p instruction --qos=instruction -A f2026.chem.5800.02 --tasks-per-node=4 --cpus-per-task=4
# don't run this directly, use salloc first

module load cmake
module load openmpi 
module load openblas/0.3.21-zniqbxh

# ./config 
# run and complete the configuration process
# and get paths according to the attached install.info.nova.example
## 
make modules
make ddi
make -j4

## build will be successful ifi t says
## GAMESS will be linked into the binary file gamess.00.x.
### and later:
## The linking of GAMESS to binary gamess.00.x was successful.

# test by doing ./rungms-dev ./tests/standard/exam01.inp 00 1 1 &> exam01.log



