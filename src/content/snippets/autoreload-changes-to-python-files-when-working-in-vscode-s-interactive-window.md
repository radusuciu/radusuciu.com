+++
date = 2021-04-28T07:00:00Z
title = "Autoreload changes to python files when working in VSCode's interactive Window"

+++
```python
%reload_ext autoreload
%autoreload 2
```

Can also add this to `settings.json`:

```json
"jupyter.runStartupCommands": [
    "%load_ext autoreload", "%autoreload 2"
],
```