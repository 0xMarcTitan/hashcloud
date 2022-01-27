<h1 align="center">Welcome to hashcloud 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/theirsecurity/hashcloud" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> This script sets up a cloud server automatically with Hashcat, Seclist and OpenCL drivers and GPU Drivers to enable hashcat to run on the cloud with minimal user set up. I have tested this on multiple hosting platforms (Vultr, Digital Ocean and CoreWeave) and evidence of this can be seen either on my blog or youtube. This version adds support for 4 different linux distributions. .

### 🏠 [Homepage](https://github.com/theirsecurity/hashcloud)

## Install

```sh
git clone https://github.com/theirsecurity/hashcloud
```

## hascloud vs hashcloud2500

If you intend to use hashcat mode 2500 you can use the hashcloud2500 script.
This will install Hashcat V6.1.1 where mode 2500 is still supported 

## Usage

```sh
Identify the script that applies to your cloud server then use
chmod +x BASH_SCRIPT_NAME
./BASH_SCRIPT_NAME

This will bring up the help section

To set which linux distribution you will be installing on use one of the below

./hashcat.sh -o deb #This is for any debian based distros
./hashcat.sh -o fedora
./hashcat.sh -o arch
./hashcat.sh -o ubuntu

Optional, to set which GPU will be installed add one of the following;

-g n #This will install nvidia GPUS
AMD GPU's - This functionality will be added in future, The cloud providers I've been testing with did not have any instances that used AMD GPU's to verify it works

Once this has run you need to copy over the hash file you want to use with hascat, i did this using SCP to the /root/hashes folder e.g
scp /INSERT_LOCAL_HASH_DIRECTORY CLOUD_USERNAME@CLOUD_IP:/hashes
```

## Author

👤 **Marc@theirsecurity.com**

* Website: https://theirsecurity.com
* Github: [@theirsecurity](https://github.com/theirsecurity)
