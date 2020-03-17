+++
date = ""
title = "Calculate CIDR ranges with an IP address or range excluded"

+++
Make this Python 3 script and name it `exclude.py` (or whatever you fancy):

```python
from ipaddress import ip_network
import sys

all_ips = ip_network('0.0.0.0/0')
arg = ip_network(sys.argv[1])
print(",".join([str(x) for x in list(all_ips.address_exclude(arg))]))
```

And use like this: `python exclude.py 172.29.0.0/16` or `python exclude.py 192.168.1.1`.