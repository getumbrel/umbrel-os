# Umbrel Box Base Operating system

![Run Release Script on push to MASTER](https://github.com/getumbrel/os-base/workflows/Run%20Release%20Script%20on%20push%20to%20MASTER/badge.svg)


Customized Underlying Raspbian Operating System for the Umbrel box (based on https://github.com/RPi-Distro/pi-gen)

## Config/Build instructions

1. Run ```sudo ./build.sh```
2. Look in deploy/
3. Use etcher to deploy

Alternatively, you may check the latest release too and you may find the image built automatically by github (upon tagging).

## Default logins

Hostname: umbrel.local
Username: umbrel
Password: umbr3lb0x

You may also find them [here](https://github.com/getumbrel/os-base/wiki/Box-System-Defaults)

### Config variables

In the config file there are system defaults, which are used when building the image and for automated builds.

* **GITHUB_USERNAME** - Used if you want to automatically log in to the box without typing a password. This is used at build time.

Then theres other raspbian stuff, that you may find in the [Raspbian documentation](https://github.com/RPi-Distro/pi-gen/blob/master/README.md) which will still work.

## Post bootup checks

For building an API (or scripting), look in /home/umbrel/statuses for the following files

* **disk-partitioned** : meaning the disk is partitioned
* **service-configured** : meaning the umbrel system bootup service is configured and running.

(To add more later as needed)

## Console Commands (Cheat codes)
There is some console commands you can run.

### Lightning Console Commands

#### Get Info

```
docker exec -it "${USER}_lnd_1" lncli getinfo
```

#### Wallet Balance

```
docker exec -it "${USER}_lnd_1" lncli walletbalance
```

#### List Channels

```
docker exec -it "${USER}_lnd_1" lncli listchannels
```

#### Opening a channel

```bash
# where XXX = sats per byte and YYY = the amount
docker exec -it "${USER}_lnd_1" lncli connect pubkey@host:port
docker exec -it "${USER}_lnd_1" lncli open --sat_per_byte=XXX pubkey YYY
# Return value is the txid
```

## TODO:

See the [following list](https://github.com/getumbrel/os-base/labels/TODO)


