+++
date = ""
title = "Calculate CIDR ranges with an IP address or range excluded"

+++
Make this Python 3 script and name it `exclude.py` (or whatever you fancy):

```python
import ipaddress
import sys
all = ipaddress.ip_network('0.0.0.0/0')
arg = ipaddress.ip_network(sys.argv[1])
print(",".join([str(x) for x in list(all.address_exclude(arg))]))
```

And use like this: `python exclude.py 172.29.0.0/16` or `python exclude.py 192.168.1.1`.