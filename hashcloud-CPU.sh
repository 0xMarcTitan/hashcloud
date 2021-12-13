#!/bin/bash
# Created by marc@theirosecurity.com
# Created on 13/12/2021
# Created specifcally for CPU using opencl
# Please see readme on github @ https://github.com/theirsecurity/cloudcat

# Make the needed directories
cd /root
mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl

# Install OpenCL
cd /hashcat
apt install opencl-headers -y
apt install pocl-opencl-icd -y

#Install Hashcat and Dependencies
apt install cmake build-essential -y
apt install checkinstall git -y
git clone https://github.com/hashcat/hashcat.git
cd hashcat && git submodule update --init && make && make install

# Clone wordlist and unpack full rockyou dictionary
cd /root/wordlists
git clone https://github.com/danielmiessler/SecLists /root/wordlists/SecLists
tar -xf /root/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /root/wordlists/SecLists/
