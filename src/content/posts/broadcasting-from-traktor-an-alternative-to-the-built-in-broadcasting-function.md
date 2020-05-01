+++
date = ""
title = "Broadcasting from Traktor: an alternative to the built in broadcasting function"

+++
This is a quick post to describe a method of streaming from Traktor to an [Icecast](http://icecast.org/) station using [`ffmpeg`](https://www.ffmpeg.org/) - though with some tweaks you can adapt this to many other endpoints. The built in broadcasting in Traktor functional but limited - you can also stream to Icecast or Shoutcast servers using the Ogg format - which is a great default, but sometimes you need something more. The other common alternative is to output from your controller/mixer to another soundcard or capture device of some sort, which you can then feed into a program like [butt](https://danielnoethen.de/butt/) or [OBS](https://obsproject.com/). This works great, but requires additional cables and hardware.

An alternative that I've explored is to use `ffmpeg` to stream from a live recording. To make use of this, you have to have `ffmpeg` installed either from your package manager (Linux) or compiled from the latest source - which is actually the recommended approach. Once `ffmpeg` is installed, I start a recording in Traktor, and create a symlink from the current recording to `current.wav` - you can skip this, but I prefer the convenience of not having to change the command line arguments at all. The full command is below.

```bash
ffmpeg \
-re \
-sseof -1 \
-i current.wav \
-acodec libvorbis \
-content_type "application/ogg" \
icecast://source:hackme@localhost:8000/radio.ogg
```

The `-re` flag is added to avoid reading to the end of the file since we're constantly writing to the recording. `-sseof 1` is used to start streaming a second before the end of the current recording. The other options specify the codec to encode with, the content type, and the destination - in this case a local Icecast server. The above code doesn't by itself offer much if anything on top of Traktor's broadcast capabilities, but, you can easily change from `Ogg` to `MP3` or `AAC`, and of course you can also combine with video or images from various sources. Basically you can combine this with anything that `ffmpeg` can do.. which is a lot!

My next steps (which if I'm being honest with myself, I'll likely never explore) would be to do all of this in code with a library like [`ffmpeg-python`](https://github.com/kkroening/ffmpeg-python). This would allow for more advanced configuration without needing to wade into the arcane world of `ffmpeg` command line arguments. Additionally, I'd like to be able to capture metadata from Traktor about the currently playing song, which could be implemented by leveraging Traktor's broadcast functionality not for the audio content, but exclusively for the metadata. This is implemented in [Traktor Metadata Listener](https://www.disconova.com/utu/traktor-metadata/), but the code for this [is not open-source](https://www.native-instruments.com/forum/threads/traktor-metadata-listener-is-back-v0-0-5.341593/#post-1819873) ([or is it??](https://github.com/DiscoNova/traktor-metadata-samples)). Conceptually, this isn't too difficult, just start up any web-server and grab the metadata from the `Ogg` stream.. of course it's easier said than done if you're not too familiar with `Ogg`.

I've also asked for some feedback on this [on SuperUser](https://superuser.com/questions/1547143/streaming-from-audio-file-that-is-being-written-to-using-ffmpeg).