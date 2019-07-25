#!/bin/bash

#OS (Ubuntu/Denial)
#Series (e.g. 4.1)
#Version (e.g. 4.1.0)
#Release (e.g. 1)
#Flavor(e.g. Ubuntu - xenial/bionic/cosmic/disco/eoan, Debian - buster/stretch/bullseye)

os=$1
flavor=$2
series=$3
version=$4
release=$5

#Keys required in debian builds
declare -a debuild_keys
debuild_keys=("8B7C364430B66F0B084C0B0C55339A4C6A7BD8D4",
              "55F839E173AC06F364120D46FA86EEACB306CEE1",
              "32F8E2FDBE1460F94A62407E468C889BEEDF12A8",
              "F9C958A3AEE0D2184FAD1CBD43607F0DC2F8238C")

declare -a pbuild_keys
pbuild_keys=("7F6E5563", "EFCE7625", "4061252D", "BF11C87C")

#Check for OS(Ubuntu or Debian)
if [ "$os" == "ubuntu" ]; then
        mirror="http://ubuntu.osuosl.org/ubuntu/"
	debuild_key=4F5B5CA5
else
        mirror="http://ftp.us.debian.org/debian/"
	case ${series} in 
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
fi

cd src/github/glusterfs-debian/

git checkout -b ${flavor}-${series}-local origin/${flavor}-glusterfs-${series}

sed -i "1s/^/glusterfs (${version}-${os}1~${flavor}1) ${flavor}; urgency=medium\n\n  * GlusterFS ${version} GA\n\n -- GlusterFS GlusterFS deb packages <deb.packages@gluster.org>  `date +"%a, %d %b %Y %T %z"` \n\n" debian/changelog

git commit -a -m "Glusterfs ${version} G.A (${flavor})"

git push origin ${flavor}-${series}-local:${flavor}-glusterfs-${series}

sudo pbuilder create --distribution ${flavor} --mirror ${mirror} --debootstrapopts "--keyring=/usr/share/keyrings/`${os}`-archive-keyring.gpg"

cd

mkdir build packages

cd ~/build

TGZS=(`ls ~/glusterfs-${version}-?-*/build/glusterfs-${version}.tar.gz`)
echo ${TGZS[0]}

if [ -z ${TGZS[0]} ]; then
        echo "wget https://download.gluster.org/pub/gluster/glusterfs/${series}/${version}/glusterfs-${version}.tar.gz"
        wget https://download.gluster.org/pub/gluster/glusterfs/${series}/${version}/glusterfs-${version}.tar.gz
else
        echo "found ${TGZS[0]}, using it..."
        cp ${TGZS[0]} .
fi

ln -s glusterfs-${version}.tar.gz glusterfs_${version}.orig.tar.gz

tar xpf glusterfs-${version}.tar.gz

cd glusterfs-${version}

cp -a /home/glusterpackager/src/github/glusterfs-debian/debian .

debuild -S -sa -k${debuild_key}

cd ..

if [ "$os" == "ubuntu" ]; then
        dput ppa:gluster/glusterfs-${series} glusterfs_${version}-ubuntu1~${flavor}${release}_source.changes
	cd ..
	mkdir glusterfs-${version}-${release}-${flavor}
	mv build glusterfs-${version}-${release}-${flavor}/
else
	sudo pbuilder build glusterfs_${version}-${release}.dsc | tee build.log
	cd ~/packages
	cp /var/cache/pbuilder/result/glusterfs*${version}-${release}*.deb .
	/usr/share/debdelta/dpkg-sig -v -k ${pbuild_key} --sign builder glusterfs-*${version}-${release}*.deb
	cd /var/www/repos/apt/debian/
	rm -rf pool/* dists/* db/*
	cp ~/conf.distributions/${series} conf/distributions
	for i in ~/packages/glusterfs-*${version}-${release}*.deb; do reprepro includedeb $flavor $i; done
	reprepro includedsc ${flavor} ~/build/glusterfs_${version}-${release}.dsc
	mkdir ~/glusterfs-${version}-${release}
	tar czf ~/glusterfs-${version}-${release}/${flavor}-apt-amd64-${version}.tgz pool/ dists/
	cd
	mv build packages glusterfs-${version}-${release}/

echo "Done."
