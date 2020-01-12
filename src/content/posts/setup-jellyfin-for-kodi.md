+++
date = 2020-01-11T08:00:00Z
draft = true
title = "Setup Jellyfin for Kodi with Native Mode and NFS"

+++
This short post details my [Jellyfin for Kodi](https://github.com/jellyfin/jellyfin-kodi) setup. The information that is readily found through google and in the project docs is a bit overly complicated - at least right now.

Some basic info: I use [Jellyfin](https://jellyfin.org/) as a media server and [Kodi](https://kodi.tv/) to play these media files over the network using the Jellyfin for Kodi addon. I have Jellyfin 10.4.3 running in Docker on Ubuntu Server 18.04 and Kodi 18.5 running on a Nvidia Shield Pro (2019).

1. Add NFS video source to Kodi but set to not scan, scrape, update etc.
2. Configure network share path (must match Step 1 exactly) for corresponding library in Jellyfin. From the Jellyfin Dashboard, go to Libraries, select a Library and add or edit Folders: ![](https://i.imgur.com/9QtITsY.png)
3. Install addon following [instructions from the official docs](https://web.archive.org/web/20200102222926/https://jellyfin.org/docs/general/clients/installing-kodi.html) and selecting Native Mode Configuration.

And that's it! No need for SMB shares with hardcoded users, or use of Windows paths at all!