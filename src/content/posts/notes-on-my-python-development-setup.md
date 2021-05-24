+++
date = 2021-05-07T05:00:00Z
title = "Notes on my Python development setup"

+++
These are just some notes on my current development setup on Windows 10 WSL2 (Ubuntu 20.04). These days I'm primarily writing code in Python so this post focuses on that. I based this on the excellent [`Hypermodern Python`](https://cjolowicz.github.io/posts/hypermodern-python-01-setup/) setup chapter.

## Python Setup

### pyenv

I use [`pyenv`](https://github.com/pyenv/pyenv) to manage python versions. `pyenv` actually builds python from source so it requires a few dependencies:

```bash
sudo apt-get update
sudo apt-get install --no-install-recommends -y make build-essential libssl-dev \
    zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

Then we can install `pyenv`

```bash
# !!! WARNING !!!
# You should inspect the contents of this url before piping into bash
curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init --path)"' >> ~/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

source ~/.profile

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

source ~/.bashrc
```

and then python:

```bash
pyenv install 3.9.4
pyenv local 3.9.4
```

### poetry

I've only recently started using [`poetry`](https://python-poetry.org/) but I'm very happy with it as for me it replaces `setuptools`, `twine` and `pip`. It has decently fast dependency resolution and generates `.lock` files that are very nice to create reproducible environments. Installation is very simple, though please note that like with `pyenv` above, the recommended installation method pipes a script that is hosted online into `python` in this case - so make sure you at least check out the script, or download separately, inspect, then run.

```bash
# !!! WARNING !!!
# You should inspect the contents of this url before piping into python
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source $HOME/.poetry/env
```

For best compatibility with VSCode, at least at time of writing, it's best to configure it to store virtual environments in the current directory like so:

```bash
poetry config virtualenvs.in-project true
```

## Other tweaks

I encountered a few issues that hopefully will be fixed in the future but I'm documenting them here for posterity.

### Lack of network connectivity with WSL2

On my current machine I started off with WSL1 and then later upgraded to WSL2. Upon the update being completed, my DNS did not work, so domain names could not be resolved. See details [here](https://github.com/microsoft/WSL/issues/5336), but what worked for me was editing `/etc/resolv.conf` to specify nameservers:

```
nameserver 1.1.1.1 1.0.0.1
```

The above IP addresses corresponds to Cloudflare's DNS resolver, but you can substitute whatever, including corporate DNS servers. To prevent my changes to `/etc/resolv.conf` being overwritten, I created`/etc.wsl.conf` with the following contents:

```
[network]
generateResolvConf = false
```

I found that somehow my `/etc/resolv.conf` was overwritten anyway, with a link, so I `sudo unlink /etc/resolv.conf` and once again added the nameserver as above, and this time the changes stuck. After closing out of my Windows Terminal window and then opening a new window, DNS resolution worked!

### Setting Windows Terminal to open with Linux home directory

By default Windows Terminal opens WSL to the Windows home directory. To use the Linux home directory instead, I went to the Windows Terminal settings for the WSL profile, and changed the starting directory to `//wsl$/Ubuntu-20.04/home/radu/`. See [this issue](https://github.com/microsoft/terminal/issues/2743) for more details.

### Adding "Windows Terminal here" to right-click context menu

I believe this is built in to later Windows Terminal versions, but I installed Windows Terminal using `scoop` (which you might do if the Microsoft Store is disabled), and this didn't come built in. However, you can still get this functionality using this script: https://github.com/grimux/windowsterminal-shell-scoop. Note that the script requires Powershell 7, which you can also install using scoop (`scoop install pwsh`).

### Keyboard shortcut for launching Windows Terminal

You can install AutoHotKey and use [this script](https://gist.github.com/atruskie/99a498ac43b91deb91eab4069b6047b9) to launch Windows Terminal with Win + \`.

### Aliases

#### docker-compose

Depending on what I'm doing I can end up typing `sudo docker-compose` a lot during a day. Others have more complex workflow, but I just alias `sudo docker-compose` as `dc`:

```bash
echo "alias dc='sudo docker-compose'" >> ~/.bashrc
source ~/.bashrc
```

### WSL2 absolutely murdering my RAM

See [this beast of an issue](https://github.com/microsoft/WSL/issues/4166). In the Windows home user directory, create a `.wslconfig` file containing:

```
[wsl2]
memory=4GB
swap=0
localhostForwarding=true
```

The last line is unrelated to memory issues and has to do with allowing me to access the container from Windows using `localhost`.

### Accessing WSL2 from Windows Explorer

One benefit of WSL2 over the original is that you can now safely access and manipulate Linux files from Windows. You can see all files by entering `\\wsl$\` into Windows Explorer -- unless you're like me and for some reason it doesn't work, except on the command line.. in which case maybe this [issue comment](https://github.com/microsoft/WSL/issues/4027#issuecomment-496628274) will help.

## Other software used

* [VSCode](https://code.visualstudio.com/) (+ Python, Docker, and Remote extensions)
* [`gh`](https://github.com/cli/cli). A CLI tool for GitHub, installed in WSL2
* [`scoop`](https://scoop.sh/). I use scoop to install everything I can