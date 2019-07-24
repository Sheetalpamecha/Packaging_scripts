#!/bin/bash
series=$1
version=$2
release=$3
os=$4
flavor=$5

if [ $# -eq 3 ]; then
        echo "building everything"
fi
if [ $# -gt 3 ]; then
    if [ "$os" == "all" ]; then
        echo "packing all distribution"
        echo "packing debian distribution"
        ssh root@fedora1 << EOF
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
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "buster" ] || [ "$flavor" == "10" ]; then
        echo "packing debian buster alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "bullseye" ] || [ "$flavor" == "11" ]; then
        echo "packing debian bullseye alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
    elif [ "$os" == "ubuntu" ]; then
        echo "packing ubuntu alone"
        if [ "$flavor" == "xenial" ] || [ "$flavor" == "16.04" ]; then
        echo "packing xenial alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "bionic" ] || [ "$flavor" == "18.04" ]; then
        echo "packing bionic alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "cosmic" ] || [ "$flavor" == "18.10" ]; then
        echo "packing cosmic alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "disco" ] || [ "$flavor" == "19.04" ]; then
        echo "packing disco alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
        if [ "$flavor" == "eoan" ] || [ "$flavor" == "19.10" ]; then
        echo "packing eoan alone"
        ssh root@fedora1 << EOF
        ./generic_package.sh $os $flavor $series $version $release
EOF
        fi
    fi
fi


