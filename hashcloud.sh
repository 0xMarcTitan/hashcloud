#!/bin/bash
#Test Script + Root Check + All versions
# V0.6.0 added Deb,Arch,Fedora,Ubuntu

#Vars
OS=""
GRAPHICS=""
VERS="0.6.0"

#border function
border()
{
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}

#Help and Welcome
usage() {
  echo "██   ██  █████  ███████ ██   ██  ██████ ██       ██████  ██    ██ ██████  "
  echo "██   ██ ██   ██ ██      ██   ██ ██      ██      ██    ██ ██    ██ ██   ██ "
  echo "███████ ███████ ███████ ███████ ██      ██      ██    ██ ██    ██ ██   ██ "
  echo "██   ██ ██   ██      ██ ██   ██ ██      ██      ██    ██ ██    ██ ██   ██ "
  echo "██   ██ ██   ██ ███████ ██   ██  ██████ ███████  ██████   ██████  ██████  "
  echo ""
  echo "Version:        $VERS"
  echo "Created By:     marc@theirsecurity.com"
  echo "Github Release: http://github.com/theirsecurity/hashcloud"
  border "Supported OS"
  echo "To select which OS you want to use run ./hashcloud -o XXX"
  echo "Debian Linux  -o deb"
  echo "Arch Linux    -o arch"
  echo "Fedora Linux  -o fedora"
  echo "Ubuntu        -o ubuntu"
  echo ""
  border "Supported GPU"
  echo "GPU support will be included in future release"
  echo ""
}
exit_abnormal() {
  usage
  exit 1
}

#Get opts
while getopts ":o:h:g:" options; do
  case "${options}" in
    o)
     OS=${OPTARG}
     ;;
    :)
    echo "ERROR: -${OPTARG} requires an argument"
    exit_abnormal
    ;;
    h)
    exit_abnormal
    ;;
    g)
    GRAPHICS=${OPTARG}
    ;;
  esac
done

#Check if a valid os Selected
if [[ $OS = "deb" ]] || [[ $OS = "arch" ]] || [[ $OS = "ubuntu" ]] || [[ $OS = "fedora" ]]
then
  echo ""
else
  border "ERROR:Invalid OS Selected"
  exit_abnormal
fi

#If options selected move to root check
if [[ $EUID -ne 0 ]]; then
  border "ERROR: This script needs to run as root for package installation"
  exit_abnormal
fi

#check GPU option
if [[ $GRAPHICS = "n" ]]
then
  echo "Nvidia GPU Selected"
elif [[ $GRAPHICS = "a" ]]
then
  echo "AMD GPU Selected"
elif [[ $GRAPHICS = "" ]]
then
  echo "GPU support will be added in future release"
else
  echo "ERROR:Invalid GPU selected"
  exit_abnormal
fi

#Confirm install
if [[ $GRAPHICS = "" ]]
then
while true; do
    read -p "You have selected $OS with CPU only support, This will install Hashcat,OpenCL and Seclists. Do you wish to continue?" yn
    case $yn in
        [Yy]* ) echo "Continue with Install"; break;;
        [Nn]* ) echo "Aborting" && exit_abnormal;;
        * ) echo "Please answer yes or no.";;
    esac
done
else
  while true; do
      read -p "GPU Support will be added in a future release, do you want to continue with CPU support for $OS" yn
      case $yn in
          [Yy]* ) break;;
          [Nn]* ) echo "Aborting" && exit_abnormal;;
          * ) echo "Please answer yes or no.";;
      esac
  done
fi

#install commands based on OS
if [[ $OS = "deb" ]] || [[ $OS = "ubuntu" ]]
then
  cd /root
  mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl
  cd hashcat
  apt install opencl-headers -y
  apt install pocl-opencl-icd -y
  apt install cmake build-essential -y
  apt install checkinstall git -y
  git clone https://github.com/hashcat/hashcat.git
  cd hashcat && git submodule update --init && make && make install
  cd /root/wordlists
  git clone https://github.com/danielmiessler/SecLists /root/wordlists/SecLists
  tar -xf /root/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /root/wordlists/SecLists/
  cd /root
elif [[ $OS = "fedora" ]]
then
  cd /root
  mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl
  cd hashcat
  dnf install opencl-headers -y
  dnf install pocl -y
  dnf install ocl-icd -y
  dnf install cmake -y
  dnf group install "C Development Tools and Libraries" -y
  dnf install git -y
  git clone https://github.com/hashcat/hashcat.git
  cd hashcat && git submodule update --init && make && make install
  cd /root/wordlists
  git clone https://github.com/danielmiessler/SecLists /root/wordlists/SecLists
  tar -xf /root/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /root/wordlists/SecLists/
elif [[ $OS = "arch" ]]
then
  cd /root
  mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl
  cd hashcat
  pacman -S opencl-headers --noconfirm
  pacman -S pocl --noconfirm
  pacman -S cmake --noconfirm
  pacman -S git --noconfirm
  git clone https://github.com/hashcat/hashcat.git
  cd hashcat && git submodule update --init && make && make install
  cd /root/wordlists
  git clone https://github.com/danielmiessler/SecLists /root/wordlists/SecLists
  tar -xf /root/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /root/wordlists/SecLists/
else
  echo "ERROR:Invalid OS Selected"
  exit_abnormal
fi

#Confirmation Messahe
border "Install Complete"


exit 0
