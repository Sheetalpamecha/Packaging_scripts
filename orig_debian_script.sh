#!/bin/bash

declare -a debuild_keys

debuild_keys=("8B7C364430B66F0B084C0B0C55339A4C6A7BD8D4",
              "55F839E173AC06F364120D46FA86EEACB306CEE1",
              "32F8E2FDBE1460F94A62407E468C889BEEDF12A8",
              "F9C958A3AEE0D2184FAD1CBD43607F0DC2F8238C")

declare -a pbuild_keys
pbuild_keys=("7F6E5563", "EFCE7625", "4061252D", "BF11C87C")

echo "Hi, Please enter your inputs exactly like how it is mentioned in the examples(Eg)"

echo "Enter Series (e.g. 4.0)"
read SERIES

echo "Enter Version (e.g. 4.0.0, enter the full string(4.0.0) and not 1 alone)"
read VERSION

echo "Enter Release (e.g. 1)"
read RELEASE

echo "Enter your username to copy the source debian"
read UNAME

echo "$UNAME is building glusterfs-${VERSION}-$RELEASE for stretch"

echo "enter y or n to continue (y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

case ${SERIES} in
  "3.12")
    debuild_key=${debuild_keys[0]}
    pbuild_key=${pbuild_keys[0]}
    ;;
  "4.0")
    debuild_key=${debuild_keys[1]}
    pbuild_key=${pbuild_keys[1]}
    ;;
  "4.1")
    debuild_key=${pbuild_keys[2]}
    pbuild_key=${pbuild_keys[2]}
    ;;
  "5" | "6" | "7")
    debuild_key=${pbuild_keys[3]}
    pbuild_key=${pbuild_keys[3]}
esac

mkdir build packages

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

cp -a /home/$UNAME/src/github/glusterfs-debian/debian .

debuild -S -sa -k${debuild_key}

cd ..

sudo pbuilder build glusterfs_${VERSION}-${RELEASE}.dsc | tee build.log

cd ~/packages

cp /var/cache/pbuilder/result/glusterfs*${VERSION}-${RELEASE}*.deb .

/usr/share/debdelta/dpkg-sig -v -k ${pbuild_key} --sign builder glusterfs-*${VERSION}-${RELEASE}*.deb

cd /var/www/repos/apt/debian/

rm -rf pool/* dists/* db/*

cp ~/conf.distributions/${SERIES} conf/distributions

for i in ~/packages/glusterfs-*${VERSION}-${RELEASE}*.deb; do reprepro includedeb stretch $i; done
reprepro includedsc stretch ~/build/glusterfs_${VERSION}-${RELEASE}.dsc

mkdir ~/glusterfs-${VERSION}-${RELEASE}

tar czf ~/glusterfs-${VERSION}-${RELEASE}/stretch-apt-amd64-${VERSION}.tgz pool/ dists/

cd

mv build packages glusterfs-${VERSION}-${RELEASE}/

echo "Done. Don't forget to push your changes to github"
