# Nova SBATCH Scripts

Scripts in this folder:

| File | Purpose |
|------|---------|
| `nova_build_gamess.sh` | Commands for building GAMESS on Nova |
| `install.info.nova.example` | Example `install.info` for the GAMESS configuration |
| `rungms-dev-nova` | Replacement `rungms-dev` for Nova |
| `nova_run_gamess_batch.sh` | SBATCH script to run a GAMESS input |

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
   module load openblas/0.3.21-zniqbxh
   ```
4. Run the configuration and answer the prompts, using `install.info.nova.example` as a guide for paths:
   ```bash
   ./config
   ```
   <!-- TODO: details on config answers -->
5. Build:
   ```bash
   make modules
   make ddi
   make -j4
   ```
6. The build succeeded if you see `The linking of GAMESS to binary gamess.00.x was successful.`
7. Copy `rungms-dev-nova` over `rungms-dev` in the GAMESS directory:
   ```bash
   cp rungms-dev-nova rungms-dev
   ```
8. Test:
   ```bash
   ./rungms-dev /path/to/gamess/tests/standard/exam01.inp 00 1 1 &> exam01.log
   ```

## 2. Run a Job

1. Edit `nova_run_gamess_batch.sh`:
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

