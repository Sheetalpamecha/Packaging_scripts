#!/bin/bash
password=$1
series=$2
version=$3
release=$4
os=$5
flavor=$6

if [ $# -eq 3 ]; then
        echo "building everything"
fi
if [ $# -gt 3 ]; then
    if [ "$os" == "all" ]; then
        echo "packing all distribution"
        echo "packing debian distribution"
        ssh glusterpackager@fedora1 << EOF
        ./generic_package.sh debian stretch $series $version $release
        ./generic_package.sh debian buster $series $version $release
        ./generic_package.sh debian bullseye $series $version $release
        echo "packing ubuntu distribution"
        ./generic_package.sh debian stretch $series $version $release
        ./generic_package.sh ubuntu xenial $series $version $release
        ./generic_package.sh ubuntu bionic $series $version $release
        ./generic_package.sh ubuntu cosmic $series $version $release
        ./generic_package.sh ubuntu disco $series $version $release
        ./generic_package.sh ubuntu eoan $series $version $release
EOF
    elif [ "$os" == "debian" ]; then
        echo "packing debian alone"
        if [ "$flavor" == "stretch" ] || [ "$flavor" == "9" ]; then
        echo "packing debian stretch alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-16.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "buster" ] || [ "$flavor" == "10" ]; then
        echo "packing debian buster alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-19.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "bullseye" ] || [ "$flavor" == "11" ]; then
        echo "packing debian bullseye alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-12.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
    elif [ "$os" == "ubuntu" ]; then
        echo "packing ubuntu alone"
        if [ "$flavor" == "xenial" ] || [ "$flavor" == "16.04" ]; then
        echo "packing xenial alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "bionic" ] || [ "$flavor" == "18.04" ]; then
        echo "packing bionic alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "cosmic" ] || [ "$flavor" == "18.10" ]; then
        echo "packing cosmic alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "disco" ] || [ "$flavor" == "19.04" ]; then
        echo "packing disco alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "eoan" ] || [ "$flavor" == "19.10" ]; then
        echo "packing eoan alone"
        sshpass -p $password ssh -o StrictHostKeyChecking=no glusterpackager@rhs-vm-17.storage-dev.lab.eng.bos.redhat.com << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
    fi
fi


