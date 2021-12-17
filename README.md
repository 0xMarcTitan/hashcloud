<h1 align="center">Welcome to hashcloud 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-0.6-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/theirsecurity/hashcloud" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> This script sets up a cloud server automatically with Hashcat, Seclist and OpenCL drivers to enable hashcat to run on the cloud with minimal user set up. I have tested this on Vultr's hosting platform and evidence of this can be seen either on my blog or youtube. This version adds support for 4 different linux distributions. GPU support is mentioned in the code which will be added in a future release.

### 🏠 [Homepage](https://github.com/theirsecurity/hashcloud)

## Install

```sh
git clone https://github.com/theirsecurity/hashcloud
```

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

Once this has run you need to copy over the hash file you want to use with hascat, i did this using SCP to the /root/hashes folder e.g
scp /INSERT_LOCAL_HASH_DIRECTORY CLOUD_USERNAME@CLOUD_IP:/hashes
```

## Author

👤 **Marc@theirsecurity.com**

* Website: https://theirsecurity.com
* Github: [@theirsecurity](https://github.com/theirsecurity)
