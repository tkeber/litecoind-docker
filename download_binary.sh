#!/usr/bin/env bash
set -x
version=$1
architecture=`uname -m`

case $architecture in
aarch64)
  archive="linux/litecoin-${version}-aarch64-linux-gnu.tar.gz"
  ;;
armv7l)
  archive="linux/litecoin-${version}-arm-linux-gnueabihf.tar.gz"
  ;;
x86_64)
  archive="linux/litecoin-${version}-x86_64-linux-gnu.tar.gz"
esac

dir="https://download.litecoin.org/litecoin-${version}/"

gpg --import thrasher-releases.asc 

curl -sko "SHA256SUMS.asc" "$dir/SHA256SUMS.asc"
curl -sko "$archive" "$dir/$archive"

gpg --verify SHA256SUMS.asc

sha256sum --ignore-missing --check SHA256SUMS.asc

tar xvfz "$archive" "litecoin-$version/bin/litecoind"
mv "litecoin-$version/bin/litecoind" "/usr/local/bin/litecoind"