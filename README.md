[![Umbrel OS](https://static.getumbrel.com/github/github-banner-umbrel-os.svg)](https://github.com/getumbrel/umbrel-os)

[![Version](https://img.shields.io/github/v/release/getumbrel/umbrel-os?color=%235351FB&label=version)](https://github.com/getumbrel/umbrel-os/releases)
[![Docker Build](https://img.shields.io/github/workflow/status/getumbrel/umbrel-os/Run%20Release%20Script%20on%20push%20to%20MASTER?color=%235351FB)](https://github.com/getumbrel/umbrel-os/actions?query=workflow%3A"Run+Release+Script+on+push+to+MASTER")
[![Chat](https://img.shields.io/badge/chat%20on-telegram-%235351FB)](https://t.me/getumbrel)

[![Twitter](https://img.shields.io/twitter/follow/getumbrel?style=social)](https://twitter.com/getumbrel)
[![Reddit](https://img.shields.io/reddit/subreddit-subscribers/getumbrel?label=Subscribe%20%2Fr%2Fgetumbrel&style=social)](https://reddit.com/r/getumbrel)


# ☂️ OS

Umbrel OS is the operating system of Umbrel Bitcoin and Lightning node. It's based on Raspberry Pi OS (formerly Raspbian) and uses [pi-gen](https://github.com/RPi-Distro/pi-gen) for customization.

## 🚀 Getting started

Umbrel OS currently supports Raspberry Pi 3 and 4. If you'd like to run it on any other hardware, please [create an issue](https://github.com/getumbrel/umbrel-os/issues/new/choose) or drop us a message in our [community chat](https://t.me/getumbrel). We'll gladly consider your request.

### Instructions:

1. Download the [latest release of Umbrel OS](https://github.com/getumbrel/umbrel-os/releases/latest), or [build the image from source](#-build-umbrel-os-from-source).
2. Use an image flasher such as [Balena Etcher](https://github.com/balena-io/etcher) to flash the image to a microSD card.
3. Put the microSD card in your Raspberry Pi, attach an external SSD or HDD (to USB 3 port), connect the Pi to your router with an ethernet cable.
4. Turn on the Pi and open http://umbrel.local from any device connected to the same network (it might take a while for it to be accessible).

**⚠️ All data on the external hard drive will be erased on first boot.**

> If you're running Umbrel OS on Bitcoin mainnet (default), the external SSD or HDD should be at least 500 GB in size (we recommend 1 TB+) so it can store the whole Bitcoin blockchain. If you do not have access to a large drive, Umbrel OS will still work by automatically enabling [pruning](https://bitcoin.org/en/full-node#reduce-storage), although you will lose access to some features.

## 💻 SSH

SSH is enabled by default and you can use the following credentials to login to your Umbrel node.

- Hostname: `umbrel.local`  
- User: `umbrel`  
- Password: `moneyprintergobrrr`

## 🛠 Build Umbrel OS from source

> Don't trust. Verify.

Step 1. Clone this repo
```
git clone https://github.com/getumbrel/umbrel-os.git
```

Step 2. Switch to repo's directory
```
cd umbrel-os
```

Step 3. BUIDL!
```
sudo ./build.sh
```

After the build completes (it can take a looooooong time), the image will be inside `deploy/` directory.

## 🔧 Advanced

**Config variables**

The `config` file has system defaults which are used when building the image and for automated builds.

- `GITHUB_USERNAME` - Use this if you want to automatically login to your node without typing a password (used at build time).

Other Raspbian-related stuff can be found in [Raspbian's documentation](https://github.com/RPi-Distro/pi-gen/blob/master/README.md) which is still applicable.

**Post bootup checks**

For building an API (or scripting), look in `/home/umbrel/statuses` for the following files

- `disk-partitioned`: meaning the disk is partitioned.
- `service-configured`: meaning the umbrel system bootup service is configured and running.

The above variables control whether or not the umbrelbox startup script is run (for SD Card safety).

If you want to overricde the checks, please delete ```service-configured``` file and add a ```disk-partitioned```, and then reinstall/configure [Umbrel](https://github.com/getumbrel/umbrel). Then run ```/etc/rc.local``` as root again (or restart your box)

---

### ⚡️ Don't be too reckless

> Umbrel is still in an early stage and things are expected to break every now and then. We **DO NOT** recommend running it on mainnet with real money just yet, unless you want to be really *#reckless*.

## ❤️ Contributing

We welcome and appreciate new contributions!

If you're a developer looking to help but not sure where to begin, check out [these issues](https://github.com/getumbrel/umbrel-os/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that have specifically been marked as being friendly to new contributors.

If you're looking for a bigger challenge, before opening a pull request please [create an issue](https://github.com/getumbrel/umbrel-os/issues/new/choose) or [join our community chat](https://t.me/getumbrel) to get feedback, discuss the best way to tackle the challenge, and to ensure that there's no duplication of work.

---

[![License](https://img.shields.io/github/license/getumbrel/umbrel-os?color=%235351FB)](https://github.com/getumbrel/umbrel-os/blob/master/LICENSE)

[getumbrel.com](https://getumbrel.com)
