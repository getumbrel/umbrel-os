# Umbrel Box Base Operating system

![Run Release Script on push to MASTER](https://github.com/getumbrel/os-base/workflows/Run%20Release%20Script%20on%20push%20to%20MASTER/badge.svg)


Customized Underlying Raspbian Operating System for the Umbrel box (based on https://github.com/RPi-Distro/pi-gen)

## Config/Build instructions

1. Run ```sudo ./build.sh```
2. Look in deploy/
3. Use etcher to deploy

Alternatively, you may check the latest release too and you may find the image built automatically by github (upon tagging).

### Config variables

In the config file there are system defaults, which are used when building the image and for automated builds.

* **GITHUB_USERNAME** - Used if you want to automatically log in to the box without typing a password. This is used at build time.

Then theres other raspbian stuff, that you may find in the [Raspbian documentation](https://github.com/RPi-Distro/pi-gen/blob/master/README.md) which will still work.

## Post bootup checks

For building an API, look in /home/umbrel for the following files

* **disk-partitioned** : meaning the disk is partitioned
* **service-configured** : meaning the umbrel system bootup service is configured.

(To add more later, maybe even put in another directory so ```$HOME``` is less cluttered)

## TODO:

See the [following list](https://github.com/getumbrel/os-base/labels/TODO)


