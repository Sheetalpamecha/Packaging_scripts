#!/bin/bash

echo "Hi, Please enter your inputs exactly like how it is mentioned in the examples(Eg)"

echo "Enter Series (e.g. 4.1)"
read SERIES

echo "Enter Version (e.g. 4.1.0, enter the full string(4.1.0) and not 1 alone)"
read VERSION

echo "Enter Release (e.g. 1)"
read RELEASE

echo "Enter the Ubuntu Release name(xenial/bionic/cosmic/disco/eoan)"
read RNAME

echo "You are trying to build glusterfs-${VERSION}-$RELEASE for $RNAME"

echo "enter y or n to continue (y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

mkdir build

cd ~/build

TGZS=(`ls ~/glusterfs-${VERSION}-?-*/build/glusterfs-${VERSION}.tar.gz`)

echo ${TGZS[0]}

if [ -z ${TGZS[0]} ]; then
        echo "wget https://download.gluster.org/pub/gluster/glusterfs/${SERIES}/${VERSION}/glusterfs-${VERSION}.tar.gz"
        wget https://download.gluster.org/pub/gluster/glusterfs/${SERIES}/${VERSION}/glusterfs-${VERSION}.tar.gz
else
        echo "found ${TGZS[0]}, using it..."
        cp ${TGZS[0]} .
fi

ln -s glusterfs-${VERSION}.tar.gz glusterfs_${VERSION}.orig.tar.gz

tar xpf glusterfs-${VERSION}.tar.gz

cd glusterfs-${VERSION}

echo "Enter your username to copy the source debian"
read UNAME

cp -a /home/$UNAME/src/github/glusterfs-debian/debian .

echo "You might double check before proceeding that debian/changelog has the changes you made."
echo "Press y if you are done(y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

debuild -S -sa -k4F5B5CA5

cd ..

dput ppa:gluster/glusterfs-${SERIES} glusterfs_${VERSION}-ubuntu1~${RNAME}${RELEASE}_source.changes

cd ..

mkdir glusterfs-${VERSION}-${RELEASE}-${RNAME}

mv build glusterfs-${VERSION}-${RELEASE}-${RNAME}/

echo "Done. Reload the Launchpad page to see the package building"
echo "Don't forget to push your changes to github."
