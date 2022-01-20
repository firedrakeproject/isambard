## Building Firedrake on Isambard

This build process describes how to install Firedrake on Isambard Phase 2
(the ARM part of the system).
Instructions for connecting to phase 2 can be found at
https://gw4-isambard.github.io/docs/user-guide/connecting.html.

You may wish to upload your Isambard public SSH key to GitHub (see
https://help.github.com/articles/connecting-to-github-with-ssh/
for how to do this).
You can build Firedrake without uploading an SSH key,
but you may see some warnings during the build processes.

Building Firedrake requires a Python installation with a working pip.
For this installation we will use the Cray Python available on Isambard

```bash
  module load cray-python/3.8.5.1
```

The build process is set out in detail in the following steps:


1. Clone this repository to somewhere in your workspace and checkout the
`alternative_install` branch

```bash
  cd /place/for/repos
  git clone https://github.com/firedrakeproject/isambard.git
  cd isambard
  git checkout -b alternative_install origin/alternative_install
```

2. You may wish to modify the line

```bash
  export NEW_VENV_NAME=firedrake
```

in `install_firedrake_isambard.sh` so that your venv has a different name.
This is mostly useful if you have multiple Firedrake installations.

3. Execute

```bash
  ./install_firedrake_isambard.sh
```

to install Firedrake.

4. Finally, you should edit the line `export VENV_NAME=firedrake`
in the file `firedrake_activate.sh`
to match the name of the venv if you edited it in step 2.
Using this script ensures that the same modules and environment
variables are set as were set at install time.

The Firedrake venv is activated by running

```bash
  source $HOME/bin/firedrake_activate.sh
```

You will need a job script to submit a job to the queue, which can be
based on the example
[here](https://github.com/firedrakeproject/isambard/blob/alternative_install/example_firedrake_jobscript.sh).
You will need to edit the jobscript with the name of the Python script
you wish to run.

Alternatively you can run a job interactively using
```bash
  qsub -I -q arm-dev -l walltime=03:00:00
```
