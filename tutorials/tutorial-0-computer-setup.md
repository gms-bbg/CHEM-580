# Set up for using GAMESS

Below are instructions which should allow using GAMESS for simple/small GAMESS calculations, with an emphasis on use in a classroom setting. This is not indended as a tutorial for setting up GAMESS for all computer systems or for jobs which need high performance.
This setup will allow you to run GAMESS for your homework assignments and small computational projects. Setting up GAMESS for parallel processing and high performance systems will be covered in a later tutorial.

## Assumptions:
It is assumed in this tutorial that the user has general knowledge of how to use a UNIX command line terminal. 

## Accessing GAMESS and using it on the Nova Cluster 

GAMESS is pre-built and setup for you use on Nova. This is the easiest way to get started with GAMESS for this course. 

- All students in CHEM-580 have access to the ISU Nova Computer Cluster: 
  - [Nova Documentation Home](https://research.it.iastate.edu/nova)
- Nova can be accessed Via:
  - SSH: [Login Instructions](https://research.it.iastate.edu/nova#logging-in)
  - VSCode Tunnel: [Tunnel Instructions](https://research.it.iastate.edu/using-vs-code-cluster)
  - Online Shell Access: [Online Shell](https://nova-ondemand.its.iastate.edu/pun/sys/shell/ssh/nova.its.iastate.edu)
- Must be connected to the ISU network, either on campus or over VPN.

### Check Access to the instruction partition 

ISU makes some of the nodes on the Nova cluster accessible via the "instruction" partition

#### Slurm
Slurm is a workload manager used on the Nova cluster to allocate compute resources for jobs, including interactive sessions and batch jobs.


#### Check nodes are accessible

To check you have access to the instruction partition you can use the sacctmgr show associations command.

``` BASH
sacctmgr show associations user=$USER
```

You should see a line in the output with the "instruction" partition listed, indicating that you have access to it.

Find your "Account"
```
sacctmgr show user $USER withassoc format=account%30,partition%20,qos%30 -n
```

There should be a line in the output with an account which reads in the form: f2026.ABCD.495.1

### Get a compute node

**You should never run compute-intensive jobs on the login nodes, which is where you will be when you first connect to the Nova cluster. Always request a compute node for such tasks using an interactive session or a batch job.**

#### Interactive Session:

A Slurm interactive session allows you to request a compute node for a limited amount of time. Meaning you have direct terminal access to the compute node(s) for running your calculations.

 You can run GAMESS interactively. To start an interactive session, use the `salloc` command with the -p instruction option to request a compute node from the instruction partition. For example:

```BASH
salloc -N 1 -p instruction -A f2026.ABCD.495.1
```

This gives you an interactive session on a compute node from the instruction partition, allowing you to run GAMESS commands directly on that node.

#### Loading GAMESS

To use GAMESS in your interactive session, you need to load the GAMESS module. This can be done using the `module load` command:

```BASH
module load gamess
```
This loads the GAMESS executable and the rungms script, allowing you to run GAMESS calculations in your interactive session.

Example:

```BASH
rungms example_inputs/standard/exam01.inp 00 1 1 &> exam01.log
```

- rungms:   
    - the script used to run GAMESS calculations in the interactive session.
- example_inputs/standard/exam01.inp:
    - the input file for the GAMESS calculation.
- exam01.log:
    - the output log file for the GAMESS calculation.
- 00 
    - The version of GAMESS to use for the calculation. For Nova always use 00
- 1 1
    - How many parallel processes. This will be discussed in a later section of the tutorial.


#### Batch Jobs:

Will be discussed in a later section of this tutorial.

## Running GAMESS on your own Computer

### Download GAMESS

Follow the instructions on https://www.msg.chem.iastate.edu/gamess/download.html to download GAMESS

You will get an email with a link, and login information. Follow the link and use the provided credentials to download the GAMESS package.

## Linux
After downloading the GAMESS package, extract it to a directory of your choice. For example, if you downloaded `gamess.tar.gz` to your home directory, you can extract it using:

```BASH
tar -xvzf gamess.tar.gz
```

This will create a `gamess` directory containing the source code and installation scripts. Follow the instructions in the `README` file within the `gamess` directory to complete the installation on your Linux system.

### Building GAMESS


run the config command and fill in the details asked for by the command line wizard.

```
cd <<YOUR_PATH_TO_GAMESS>>
./confg
```

- Operating system:
    - linux64
- Where is the GAMESS software located on your system?: 
    - ENTER for Default option
- GAMESS build directory?
    - ENTER for Default option
- Please provide a version number for the GAMESS executable. This will be used as the middle part of the binary name, for example: gamess.00.x
    - ENTER for Default option
- HPC system target for 64-bit Linux system: 
    - ENTER for Default option (none)
- Please enter your choice of FORTRAN: 
    - Enter the fortran you have installed, most likely gfortran.
- Fortran Version:
    - The version of the FORTRAN compiler you have installed, for example: 10.2 
- Enter your math library choice from one of the options below:
    - none
- communication library ('serial','sockets' or 'mpi' or 'mixed')? 
    - serial
- enter no for all remaining options. 

build the lapack library which is needed for building gamess
```BASH
make -j lapack
```

build GAMESS

```BASH
make -j 4
```

## Windows:
 
Working with GAMESS on Windows is generally not reccomended for this course. If you must use Windows, consider using a Windows Subsystem for Linux (WSL) to run GAMESS. The instructions would be the same as above for the Linux installation and build process, just done inside the WSL environment.

## Running GAMESS locally: 

After buiding or installing 

```BASH
 ./rungms-dev tests/standard/exam01.inp 00 1 1 &> exam01.log
``` 


## Mac OSX

For Mac OSX there is a dedicated precompiled version of GAMESS available. Follow the instructions on the GAMESS website to download and install the Mac OSX version. Download the June2020R1 version of the precompiled package

Extract the GAMESS download either in the terminal using:

```BASH
tar -xvzf gamess-macosx-30June2020R1.tar.gz
```

or by using the Finder to double-click the downloaded archive.

Run GAMESS on a simple test:

```BASH
gms tests/standard/exam01.inp
```

The command line will prompt you to provide an output file path, for now choose the default option or specify a path where you want the output file to be saved.

### Verify it is working

Open the output file generated by the test run and make sure the file contains the following near the end:

```
 EXECUTION OF GAMESS TERMINATED NORMALLY 14:34:06 28-AUG-2026    
```

You can search for the Hartree Fock energy in the output file to verify that the calculation ran successfully. Look for a line similar to:

```
 ITER EX DEM     TOTAL ENERGY        E CHANGE  DENSITY CHANGE    DIIS ERROR
   1  0  0      -37.1725772831   -37.1725772831   0.380764105   0.000000000
   2  1  0      -37.2279756203    -0.0553983372   0.131481807   0.000000000
   3  2  0      -37.2317322477    -0.0037566275   0.046548651   0.000000000
   4  3  0      -37.2321932103    -0.0004609626   0.016847695   0.000000000
   5  0  0      -37.2322568537    -0.0000636433   0.010114675   0.000000000
   6  1  0      -37.2322678008    -0.0000109472   0.000054437   0.000000000
   7  2  0      -37.2322678015    -0.0000000006   0.000017898   0.000000000
   8  3  0      -37.2322678015    -0.0000000001   0.000006281   0.000000000

          -----------------
          DENSITY CONVERGED
          -----------------
     TIME TO FORM FOCK OPERATORS=       0.0 SECONDS (       0.0 SEC/ITER)
     TIME TO SOLVE SCF EQUATIONS=       0.0 SECONDS (       0.0 SEC/ITER)

 FINAL RHF ENERGY IS      -37.2322678015 AFTER   8 ITERATIONS
 ```