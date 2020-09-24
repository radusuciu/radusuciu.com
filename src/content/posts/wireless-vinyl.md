+++
date = 2020-09-24T00:00:00Z
slug = "wireless-vinyl"
title = "Wireless Vinyl with Raspberry Pi"

+++
Maybe this seems a bit antithetical to the idea of vinyl, but I've found myself wanting to listen to a record I had just bought at a time when it would've disruptive to my partner, whose pandemic office is in our living room. My solution was to build a small streaming device using a [Raspberry Pi][raspi] and [snapcast][snapcast]. I've also been interested in testing snapcast for synchronous multiroom audio (the explicit purpose of this software), and was impressed by how well it worked.

![assembled hardware](/images/wireless-vinyl/cropped.jpg)

## Hardware

Although the Raspberry Pi 4 has a audio input/output, it is widely considered to offer subpar sound quality and it is recommended that you use an external soundcard - either USB- or HAT-based (Hardware Attached on Top). I opted for a HAT since I wanted an all-in one solution.

Here are the components I used with prices and purchase links:

- Raspberry Pi 4B (2GB): [$35](https://www.adafruit.com/product/4292)
- Raspberry Pi Power Supply: [$8](https://www.adafruit.com/product/4298)
- HiFiBerry DAC+ ADC Pro: [$65](https://hifiberry.us/product/dac-adc-pro/)
- Argon Neo Raspberry Pi Case: [$15](https://www.amazon.com/gp/product/B07WMG27T7)
- SanDisk 32GB SD Card: [$11](https://www.amazon.com/gp/product/B06XWMQ81P)
- SanDisk USB MicroSD Card Reader: [$13](https://www.amazon.com/gp/product/B07G5JV2B5) (already had)

And a passive audio splitter and cables:
- SwitchCraft SC600 Dual Adapter Box: [$50, used](https://reverb.com/marketplace?query=switchcraft%20sc600)
- Short AUX 3.5mm TRS cable: [$10](https://www.amazon.com/gp/product/B082PQ1G5R)
- Hosa Dual TS to Dual RCA cable: [$6](https://www.amazon.com/gp/product/B000068O16) (already had)

Total cost: ~$200 (+ some shipping costs)

Note that a lot of these can be swapped out for equivalent parts. For example, while I really like the Argon Neo case, I probably would've opted for a [purpose-built case](https://www.hifiberry.com/shop/cases/steel-case-for-hifiberry-dac-pi-4-2/) by HiFiBerry, had one been available for sale at their [US-based online store](https://hifiberry.us/). As it stands, the Argon Neo case leaves the HifiBerry exposed. Additionally, I probably could've opted for the slightly cheaper HiFiBerry DAC+ ADC ($15 cheaper than the Pro), or something like [AudioInjector's Zero sound card](http://www.audioinjector.net/rpi-zero), which is far cheaper, but requires soldering and I was turned off by the number of online reviews complaining about the lack of documentation. The Switchcraft SC600 is a bit overkill as well - but I wanted it for other applications too.

## Software

### Loading the OS
The first step is to install an OS onto the SD card using a SD card reader plugged into a computer. I installed Ubuntu Server 20.04.1 (64 bit), downloaded from [the Ubuntu website](https://ubuntu.com/download/raspberry-pi), and flashed it onto my SD card using [Rufus](https://rufus.ie/). At this point, I was able to insert the SD card and boot up, and was able to login via SSH using the IP address of the Raspberry Pi listed by my router in the DHCP allocation table and default username/password (both are ubuntu). You can also do this via WiFi by editing the `network-config` file in the `system-boot` partition of the SD card before inserting into the Pi.

### Configuring the HiFiBerry DAC+ ADC Pro

I was initially afraid that information on this would be hard to come by, but luckily HiFiBerry provide [good documentation](https://www.hifiberry.com/docs/software/configuring-linux-3-18-x/), though the specific steps I followed were a bit different, probably due to the fact that I chose to run Ubuntu.

I edited `/boot/firmware/usercfg.txt` as follows:

```shell
# Place "config.txt" changes (dtparam, dtoverlay, disable_overscan, etc.) in
# this file. Please refer to the README file for a description of the various
# configuration files on the boot partition.

dtparam=audio=off
force_eeprom_read=0
dtoverlay=hifiberry-dacplusadcpro
```

I also created `/etc/asound.conf` as advised in the docs:

```shell
pcm.!default {
  type hw card 0
}
ctl.!default {
  type hw card 0
}
```

After a reboot (`sudo reboot -h now`), I was able to list audio input/output devices using the commands: `arecord -l` and `aplay -l`, with levels that could be adjusted using `alsamixer`.

### Getting Snapcast running in Docker

Next, I installed some dependencies as well as `docker` and `docker-compose`:

```bash
sudo apt-get update && sudo apt-get upgrade
sudo apt-get -y install alsa-utils build-essential libffi-dev libssl-dev python3-dev git

# note that though this installation method is recommended on the docker docs
# it's a security risk to pipe anything straight to your shell
# you may choose to separate these into two steps so you may examine
# the script before running
curl -sSL https://get.docker.com | sh

# similar warning with the get-pip.py file used here
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo python3 get-pip.py && rm get-pip.py
sudo pip3 install docker-compose

git clone git@github.com:radusuciu/pi4snap.git && cd pi4snap
sudo docker-compose up -d
```

This uses a custom snapcast image that I made (pretty ineffeciently, but it works for me) - you can use your own, or even forego the docker install if you'd prefer.


## Conclusion

Snapcast should now be reachable at `IP_ADDRESS:1780` - you can control as well as stream here thanks to [snapweb](https://github.com/badaix/snapweb). Refer to the [snapcast][snapcast] repository for more information on control and streaming clients.


[snapcast]: https://github.com/badaix/snapcast
[raspi]: https://www.raspberrypi.org/