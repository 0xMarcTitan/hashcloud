#!/bin/bash
#V1.0.0 adds GPU support for Nvidia and finalises functions of V0.6.0

#Vars
OS=""
GRAPHICS=""
VERS="1.0.0"
GRAPHICSNAME=""

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
  border "About"
  echo "Version:        $VERS"
  echo "Created By:     marc@theirsecurity.com"
  echo "Github Release: http://github.com/theirsecurity/hashcloud"
  border "Supported OS"
  echo "To select which OS you want to use run ./hashcloud -o XXX"
  echo "Debian Linux  -o deb"
  echo "Arch Linux    -o arch"
  echo "Fedora Linux  -o fedora"
  echo "Ubuntu        -o ubuntu"
  border "Supported GPU"
  echo "To select whwich GPU you want to install add one of the following "
  echo "Nvidia  -g n"
  echo "AMD: Due to limited number of cloud providers useing AMD, This will be added later"
  echo ""
}
exit_abnormal() {
  usage
  exit 1
}

exit_restart() {
  read -p "As you have Installed support for $GRAPHICSNAME GPU's, a reboot is required to work correctly. do you want to restart now?" yn
  case $yn in
      [Yy]* ) border "Restarting Now" && echo "RESTART COMMAND SENT" && sudo reboot && exit 1;;
      [Nn]* ) border "informantion" && echo "You will need to restart for the $GRAPHICSNAME GPU to show within hashcat" && exit 1;;
      * ) echo "Please answer yes or no.";;
  esac
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
  GRAPHICSNAME="Nvidia"
elif [[ $GRAPHICS = "a" ]]
then
  echo "AMD GPU Selected"
  GRAPHICSNAME="AMD"
elif [[ $GRAPHICS = "" ]]
then
  echo "NO GPU Selected"
else
  echo "ERROR:Invalid GPU selected"
  exit_abnormal
fi

#Confirm install
if [[ $GRAPHICS = "" ]]
then
while true; do
    read -p "You have selected $OS with CPU only support, This will install OS Updates,Hashcat,OpenCL and Seclists. Do you wish to continue?" yn
    case $yn in
        [Yy]* ) echo "Continue with Install"; break;;
        [Nn]* ) echo "Aborting" && exit_abnormal;;
        * ) echo "Please answer yes or no.";;
    esac
done
else
  while true; do
      read -p "You have selected $OS, This will install OS Updates,Hashcat,OpenCL,Seclist and $GRAPHICSNAME requirements. Do you wish to continue?  " yn
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
  apt-get update -y
  apt-get upgrade -y
  mkdir /usr/share/hashcloud
  cd /usr/share/hashcloud
  mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl
  cd hashcat
  apt install opencl-headers -y
  apt install pocl-opencl-icd -y
  apt install cmake build-essential -y
  apt install checkinstall git -y
  git clone https://github.com/hashcat/hashcat.git
  cd hashcat && git submodule update --init && make && make install
  cd /usr/share/hashcloud/wordlists
  git clone https://github.com/danielmiessler/SecLists /usr/share/hashcloud/wordlists/SecLists
  tar -xf /usr/share/hashcloud/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/hashcloud/wordlists/SecLists/
  cd /usr/share/hashcloud
  if [[ $GRAPHICS = "n" ]]
  then
    apt install nvidia-driver-455 -y
    apt install nvidia-cuda-toolkit -y
    exit_restart
  elif [[ $GRAPHICS = "a" ]]
  then
    echo "AMD Drivers are not currently supported"
    #install commands for AMD
    exit_restart
  else
    exit 1
  fi


elif [[ $OS = "fedora" ]]
then
  dnf upgrade -y
  mkdir /usr/share/hashcloud
  cd /usr/share/hashcloud
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
  cd /usr/share/hashcloud/wordlists
  git clone https://github.com/danielmiessler/SecLists /usr/share/hashcloud/wordlists/SecLists
  tar -xf /usr/share/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/hashcloud/wordlists/SecLists/
  cd /usr/share/hashcloud
  if [[ $GRAPHICS = "n" ]]
  then
    dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install dnf-plugins-core -y
    sudo dnf update -y
    sudo dnf install akmod-nvidia -y
    sudo dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
    exit_restart
  elif [[ $GRAPHICS = "a" ]]
  then
    #install commands for AMD
    echo "AMD Drivers are not currently supported"
    exit_restart
  else
    exit 1
  fi

elif [[ $OS = "arch" ]]
then
  pacman -Syu --noconfirm
  mkdir /usr/share/hashcloud
  cd /usr/share/hashcloud
  mkdir ./hashes && mkdir ./hashcat && mkdir ./wordlists && mkdir ./opencl
  cd hashcat
  pacman -S opencl-headers --noconfirm
  pacman -S pocl --noconfirm
  pacman -S cmake --noconfirm
  pacman -S git --noconfirm
  git clone https://github.com/hashcat/hashcat.git
  cd hashcat && git submodule update --init && make && make install
  cd /usr/share/hashcloud/wordlists
  git clone https://github.com/danielmiessler/SecLists /usr/share/hashcloud/wordlists/SecLists
  tar -xf /root/wordlists/SecLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /usr/share/hashcloud/wordlists/SecLists/
  cd /usr/share/hashcloud
  if [[ $GRAPHICS = "n" ]]
  then
    pacman -R xf86-video-nouveau --noconfirm
    pacman -S nvidia nvidia-utils --noconfirm
    pacman -S opencl-nvidia --noconfirm
    pacman -s cuda --noconfirm
    exit_restart
  elif [[ $GRAPHICS = "a" ]]
  then
    #install commands for AMD
    echo "AMD Drivers are not currently supported"
    exit_restart
  else
    exit 1
  fi

else
  echo "ERROR:Invalid OS Selected"
  exit_abnormal
fi

#Confirmation Message
border "Install Complete"


exit 0
