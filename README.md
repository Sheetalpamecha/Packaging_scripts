# packaging-scripts

### WIP : Gluster packaging scripts.

This is an effort to automate the gluster package building job for Debian,
and Ubuntu.

### How it works:

* The [package.sh](automated_new_scripts/package.sh) is the top level script to be triggered through a Jenkin's job.
* This will ssh from the Jenkin's slave to the machines were the packaging
enviroment is set up.
* Once sshed it will trigger the scripts [generic_ubuntu_scripts.sh](automated_new_scripts/generic_ubuntu_scripts.sh) in the machines to start packaging.
