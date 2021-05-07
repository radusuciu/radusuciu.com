+++
date = 2021-05-07T05:00:00Z
draft = true
title = "Notes on my Python development setup"

+++
These are just some notes on my current development setup on Windows 10 WSL2 (Ubuntu 20.04). These days I'm primarily writing code in Python so this post focuses on that. I based this on the excellent [`Hypermodern Python`](https://cjolowicz.github.io/posts/hypermodern-python-01-setup/) setup chapter.

## Setup

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
```

For best compatibility with VSCode, at least at time of writing, it's best to configure it to store virtual environments in the current directory like so:

```bash
poetry config virtualenvs.in-project true
```

## Other software used

- [VSCode](https://code.visualstudio.com/) (+ extensions for Python and Docker)
- [`gh`](https://github.com/cli/cli), a CLI tool for GitHub