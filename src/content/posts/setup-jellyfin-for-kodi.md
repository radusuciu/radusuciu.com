+++
date = ""
draft = true
title = "Setup Jellyfin for Kodi with Native Mode and NFS"

+++
This short post details my Jellyfin for Kodi setup. The information that is readily found through google and in the project docs is a bit overly complicated - at least right now.

Some basic info: I use Jellyfin as a media server and Kodi to play these media files over the network using the Jellyfin for Kodi addon. I have Jellyfin 10.4.3 running in Docker on Ubuntu Server 18.04 and Kodi 18.5 running on a Nvidia Shield Pro (2019).

1. Add NFS video source to Kodi but set to not scan, scrape, update etc.
2. Configure network share path (must match Step 1 exactly) for corresponding library in Jellyfin. From Jellyfin Dashboard, go to Libraries, select a Library and add or edit Folders: ![](https://i.imgur.com/9QtITsY.png)
4. Install addon following [instructions from the official docs](https://web.archive.org/web/20200102222926/https://jellyfin.org/docs/general/clients/installing-kodi.html) and selecting Native Mode Configuration.
5. Add

If you already have libraries in Jellyfin and Kodi you can pretty much follow the exact directions outlined above, with these modifications:

References:

[https://jellyfin.org/docs/general/clients/installing-kodi.html](https://jellyfin.org/docs/general/clients/installing-kodi.html "https://jellyfin.org/docs/general/clients/installing-kodi.html")