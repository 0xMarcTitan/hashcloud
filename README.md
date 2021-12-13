<h1 align="center">Welcome to hashcloud 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-POC-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/theirsecurity/hashcloud" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> This script is an initial POC to set up a cloud server automatically with Hashcat, Seclist and OpenCL drivers to enable hashcat to run on the cloud with minimal user set up. I have tested this on Vultr's hosting platform and evidence of this can be seen either on my blog or youtube.

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

Once this has run you need to copy over the hash file you want to use with hascat, i did this using SCP to the /root/hashes folder e.g
scp /INSERT_LOCAL_HASH_DIRECTORY CLOUD_USERNAME@CLOUD_IP:/hashes
```

## Author

👤 **Marc@theirsecurity.com**

* Website: https://theirsecurity.com
* Github: [@theirsecurity](https://github.com/theirsecurity)

