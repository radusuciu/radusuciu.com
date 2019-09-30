+++
title = "Comparing contents of two directories"
+++

```bash
python -c 'import filecmp; filecmp.dircmp("DIR_ONE", "DIR_TWO").report()'
```

For more uses of the `filecmp` module see [PyMOTW](https://pymotw.com/3/filecmp/).