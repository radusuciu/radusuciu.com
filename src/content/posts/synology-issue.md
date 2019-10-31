+++
title = "The Internet is great: How to fix your Intel C2000 affected Synology NAS"

+++
This Monday morning I woke up to email from a colleague saying that she was having trouble accessing our Synology DS2415+ device aka. Cravault. To my immediate dismay, the device was unreachable and rebooted with a "blinking LED of death" which persisted even when I removed all the drives. Synology support told me that this indicative of a hardware failure and that it would require a motherboard replacement. A quick google revealed that devices such as mine with Intel C2000 series processors had a pretty significant hardware fault which resulted in unsually high failure rates after 18+ months. This was covered by many media outlets including [Anandtech](https://www.anandtech.com/show/11110/semi-critical-intel-atom-c2000-flaw-discovered) and documented as [Erratum AVR54](https://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/atom-c2000-family-spec-update.pdf) by Intel.

I eventually came upon a [thread on the Synology forums][synology c2000 thread] and what impressed on me was the below quote:

{{< blockquote author="polanat" link="https://forum.synology.com/enu/viewtopic.php?p=472595#p472595" title="Synology Forums" >}}
My 2 cents - based on Ohm's law - in order to reduce the voltage, the resistance has to be increased - that's the ground for the SMD resistor information leakage ...
{{< /blockquote >}}

Several pages later, posts began appearing from users who had had their units repaired by Synology, and lo and behold, comparison pics showed that the fixed motherboards had a 100Ω resistor soldered (in some cases pretty poorly) on! See [this thread on the Synology forums][synology c2000 thread] for all the drama. Most of the discussion is centered on the appropriateness of Synology's response to Intel's disclosure that these chips are expected to have higher rates of failure after 18 months.

As for my own Synology device, I'm waiting on their support to provide guidance before I go forward and attempt this fix myself.

**Update**: Synology cross-shipped a new device. I moved the drives, booted up and was back up and running like nothing happened!

[synology c2000 thread]: https://forum.synology.com/enu/viewtopic.php?f=106