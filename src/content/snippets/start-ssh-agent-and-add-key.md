+++
date = ""
title = "Start ssh-agent and add key"

+++
```bash
eval $(ssh-agent -s) && ssh-add ~/.ssh/id_rsa
```

Short though this may be, I often forget it.