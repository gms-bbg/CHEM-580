# Nova SBATCH Scripts

Scripts in this folder:

| File | Purpose |
|------|---------|
| [`nova_build_gamess.sh`](./nova_build_gamess.sh) | Commands for building GAMESS on Nova |
| [`install.info.nova.example`](./install.info.nova.example) | Example `install.info` for the GAMESS configuration |
| [`rungms-dev-nova`](./rungms-dev-nova) | Replacement `rungms-dev` for Nova |
| [`nova_run_gamess_batch.sh`](./nova_run_gamess_batch.sh) | SBATCH script to run a GAMESS input |
### 0. Do these instructions on a /work/classtmp

The home directory on Nova is restricted to 10GB

You need to be working on  
```
/work/classtmp/<NetID>
```
https://research.it.iastate.edu/hpc-class
https://research.it.iastate.edu/reducing-home-directory-usage-nova

See the documentation on 

## 1. Build GAMESS

1. Get an interactive allocation (update the account as needed):
   ```bash
   salloc -p instruction --qos=instruction -A f2026.chem.5800.02 --tasks-per-node=4 --cpus-per-task=4
   ```
2. Go to your GAMESS directory that you have downloaded from https://www.msg.chem.iastate.edu/gamess/download.html:
   ```bash
   cd /path/to/gamess
   ```
3. Load modules:
   ```bash
   module load cmake
   module load openmpi
   module load openblas/0.3.30-ilp64-bqh5gp7
   ```
4. Run the configuration and answer the prompts, using [`install.info.nova.example`](./install.info.nova.example) as a guide for paths:
   ```bash
   ./config
   ```

   prompt answers:
   
   ```
   please enter your target machine name: linux64 
   ```
   ```
   GAMESS directory? [/path/to/gamess] hit <ENTER>  no input needed (use detault)
   ```

   ```
   GAMESS build directory? [/path/to/gamess] hit <ENTER>  no input need (use detault) 
   ```
   ```
   Version? [00] hit <ENTER> (use default)
   ```
   ```
   HPC system target for 64-bit Linux system: <ENTER> 
   ```
   ```
   Please enter your choice of FORTRAN: gfortran
   ```
   ```
   Please enter only the first decimal place, such as 8.2 or 11.2: 11.4
   ```
   ```
   Enter your math library choice from one of the options below: 'acml', 'aocl', 'atlas', 'mkl', 'openblas', 'nvblas', 'armpl', 'nvpl', 'none'
   : openblas
   ```
   ```
   Where is your libopenblas64.a or libopenblas.a file located?
   enter this full pathname: /opt/rit/el9/20240815/app/linux-rhel9-x86_64_v3/gcc-11.4.1/openblas-0.3.30-bqh5gp76mxt6s26dejedwgcrvslwy5l6/lib
   ```
   ```
   LAPACK library link line: <ENTER> (not needed)
   ```
   ```
   communication library ('serial','sockets' or 'mpi' or 'mixed')? mpi
   ```
   ```
   Enter MPI library (hpcx, impi, mpich, mvapich2, mpt, openmpi, sockets): openmpi
   ```
   ```
   mpi path: /opt/rit/el9/20250815/app/linux-rhel9-x86_64_v3/gcc-11.4.1/openmpi-5.0.8-mybw4ysihjo77xmjcknse5my7koichix
   ```
   ```
   hit the <ENTER> key to continue through the rest of the prompts which no input needed

**Check that your install.info looks correct and is the same as install.info.nova.example**

5. Build:
   ```bash
   make modules
   make ddi
   make -j4
   ```
6. The build succeeded if you see `The linking of GAMESS to binary gamess.00.x was successful.`
7. Copy [`rungms-dev-nova`](./rungms-dev-nova) over `rungms-dev` in the GAMESS directory:
   ```bash
   cp rungms-dev-nova rungms-dev
   ```
8. Test:
   ```bash
   ./rungms-dev /path/to/gamess/tests/standard/exam01.inp 00 1 1 &> exam01.log
   ```


## 2. Run a Job

1. Edit [`nova_run_gamess_batch.sh`](./nova_run_gamess_batch.sh):
   - `#SBATCH -J` job name
   - `#SBATCH -t` time limit
   - `#SBATCH -N` number of nodes
   - `#SBATCH --ntasks-per-node` tasks per node
   - `#SBATCH --account` your account
   - `GMSPATH` path to your GAMESS build
   <!-- TODO: details -->
2. Submit with your input file:
   ```bash
   sbatch nova_run_gamess_batch.sh my_job.inp
   ```
3. Check the queue:
   ```bash
   squeue -u $USER
   ```
4. Output goes to `my_job.log` (next to the input) and `<jobname>-<jobid>.out`.

