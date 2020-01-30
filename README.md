## Building Firedrake on Isambard

This build process describes how to install Firedrake on Isambard Phase 2 (the ARM part of the system). Instructions for connecting to phase 2 can be found at https://gw4-isambard.github.io/docs/user-guide/connecting.html.

The build process will work better if you upload your Isambard public SSH key to GitHub (see https://help.github.com/articles/connecting-to-github-with-ssh/ for how to do this). You can build Firedrake without uploading an SSH key but you will see some warnings during the build processes. 

Building Firedrake requires a Python installation with a working pip. The Python versions available as modules on Isambard do not have a working pip so you will need to build your own Python distribution before building Firedrake.

The build process is set out in detail in the following steps:

1. Make a new directory on Isambard to use for building Firedrake. This can be called anything you like but for the purposes of these instructions we will assume the directory is `${HOME}/firedrake`:

```bash
  cd ~
  mkdir firedrake
  cd firedrake
```

2. Clone this repository and create links to the scripts:

```bash
   git clone git@github.com:firedrakeproject/isambard.git
   ln -s isambard/*.sh .
```

3. Build Python:
```bash
   bash build_python3.7_isambard.sh
```

4. Submit a job to the queue to build Firedrake :
```bash
   qsub submit_build.sh
```

Firedrake will not build on a log in node so has to run via the batch queue (you can run the build script using an interactive job if you prefer).

Additional arguments to `firedrake-install` can be passed to the `install_firedrake_isambard.sh` script by editing `submit_build.sh`.

You will need a job script to submit a job to the queue, which can be based on the example `submit_firedrake_isambard.sh`. You will need to edit the script to specify the location of your Firedrake build and the name of the Python script you want to run.
