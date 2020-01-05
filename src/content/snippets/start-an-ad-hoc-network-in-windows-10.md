+++
date = 2020-01-05T08:00:00Z
title = "Start an ad-hoc network in Windows 10"

+++
In an administrative command prompt:

```
netsh wlan set hostednetwork mode=allow ssid=SSID key=KEY
netsh wlan start hostednetwork
```

May also need to configure TCP/IPv4 for the interface in Network Connections.