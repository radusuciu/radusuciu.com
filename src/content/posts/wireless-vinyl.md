+++
date = ""
draft = true
title = "Wireless Vinyl"

+++
Maybe this seems a bit antithetical to the idea of vinyl, but I've found myself wanting to listen to a record I had just bought at a time when it would've disruptive to my partner, whose pandemic office is in our living room. My solution was to build a small streaming device using a [Raspeberry Pi][raspi] and [snapcast][snapcast]. I've also been interested in testing snapcast for synchronous multiroom audio (the explicit purpose of this software), and was impressed by how well it worked.

## Hardware

Although the Raspberry Pi 4 has a audio input/output, it is widely considered to offer subpar sound quality and it is recommended that you use an external soundcard - either USB- or HAT-based (Hardwared Attached on Top). I opted for a HAT since I wanted an all-in one solution.

Here are the components I used with prices and purchase links:

- Raspberry Pi 4B (2GB): [$35](https://www.adafruit.com/product/4292)
- Raspberry Pi Power Supply: [$8](https://www.adafruit.com/product/4298)
- HiFiBerry DAC+ ADC Pro: [$65](https://hifiberry.us/product/dac-adc-pro/)
- Argon Neo Raspberry Pi Case: [$15](https://www.amazon.com/gp/product/B07WMG27T7)
- SanDisk 32GB SD Card: [$11](https://www.amazon.com/gp/product/B06XWMQ81P)
- SanDisk USB MicroSD Card Reader: [$13](https://www.amazon.com/gp/product/B07G5JV2B5) (already had)

And a passive audio splitter :
- SwitchCraft SC600 Dual Adapter Box: [$50, used](https://reverb.com/marketplace?query=switchcraft%20sc600)
- Short AUX 3.5mm TRS cable: [$10](https://www.amazon.com/gp/product/B082PQ1G5R)
- Hosa Dual TS to Dual RCA cable: [$6](https://www.amazon.com/gp/product/B000068O16) (already had)

Total cost: ~$200

Note that a lot of these can be swapped out for equivalent parts. For example, while I really like the Argon Neo case, I probably would've opted for a [purpose-built case](https://www.hifiberry.com/shop/cases/steel-case-for-hifiberry-dac-pi-4-2/) by HiFiBerry, had one been available for sale at their [US-based online store](https://hifiberry.us/). As it stands, the Argon Neo case leaves the HifiBerry exposed. Additionally, I probably could've opted for the slightly cheaper HiFiBerry DAC+ ADC ($15 cheaper than the Pro), or something like [AudioInjector's Zero soud card](http://www.audioinjector.net/rpi-zero), which is far cheaper, but requires soldering and I was turned off by the fair number of online reviews complaining about the lack of documentation. The Switchcraft SC600 is a bit overkill as well - but I wanted this particular product for other applications as well.

## Software






[snapcast]: https://github.com/badaix/snapcast
[raspi]: https://www.raspberrypi.org/