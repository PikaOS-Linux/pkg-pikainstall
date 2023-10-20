#! /bin/bash

DEBIAN_FRONTEND=noninteractive

# Clone Upstream
cd ./pikainstall

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
