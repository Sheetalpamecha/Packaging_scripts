#!/bin/bash

#ssh spamecha@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com
#cd src/github/glusterfs-debian/
#git checkout -b bionic-glusterfs-${VERSION}-local origin/bionic-glusterfs-${VERSION}

#glusterfs (3.10.12-ubuntu1~bionic1) bionic; urgency=medium
#* GlusterFS 3.10.12.

# -- GlusterFS GlusterFS deb packages <deb.packages@gluster.org>  Thu, 12 Apr 2018 09:19:51 -0400





sed -i "1s/^/glusterfs (6.3-ubuntu1~bionic1) bionic; urgency=medium\n\n * GlusterFS 6.3 GA \n\n – GlusterFS GlusterFS deb packages <deb.packages@gluster.org> `date +"%a, %d %b %Y %T %z"` \n\n/" changelog


