#!/bin/bash

set -e

sudo apt-get update

# Install python and packages needed to build simp_le
sudo apt-get install -y git gcc musl-dev build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev

cd /usr/src
sudo wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
sudo tar xzf Python-3.5.2.tgz
cd Python-3.5.2
sudo ./configure
sudo make altinstall

curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3

# Create expected symlinks if they don't exist
[[ -e /usr/bin/pip ]] || ln -sf /usr/bin/pip3 /usr/bin/pip
[[ -e /usr/bin/python ]] || ln -sf /usr/bin/python3 /usr/bin/python

python3.5 -V

# Get Let's Encrypt simp_le client source
branch="0.16.0"
mkdir -p /src
git -C /src clone --depth=1 --branch $branch https://github.com/zenhack/simp_le.git

# Install simp_le in /usr/bin
cd /src/simp_le
#pip install wheel requests
for pkg in pip setuptools wheel
do
  pip3 install -U "${pkg?}"
done
pip3 install .

# Make house cleaning
cd /
rm -rf /src
