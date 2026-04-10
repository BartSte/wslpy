# wslpy

Bash executables that allow you to work with Python on Windows from a WSL environment.

## Description

`wpy` and `wuv` let you invoke Windows Python and uv.exe while working inside WSL. `wpy` reads the `WPY` environment variable, and `wuv` delegates to the Windows `uv.exe` executable. For example: `/mnt/c/Users/BartSte/AppData/Roaming/uv/python/cpython-3.13.7-windows-x86_64-none/python.exe`.

When a Windows `uv` build touches editable dependencies stored in WSL, the
underlying Windows `git.exe` process may reject `//wsl.localhost/...` paths as
unsafe. `wuv` now does two things by default for the current command:

- injects a temporary `safe.directory=*` override for ordinary Git subprocesses
- sets `SETUPTOOLS_SCM_IGNORE_DUBIOUS_OWNER=1` for setuptools_scm /
  `vcs_versioning` builds that would otherwise fail on the ownership check

You can still narrow it to a specific tree:

```bash
export WUV_GIT_SAFE_DIRECTORY=/home/barts/code/work/python/*
wuv run src/main.py --debug
```

`WUV_GIT_SAFE_DIRECTORY` also accepts a single repo path, a Windows path, or
`*`. To disable the default injection for a specific call, use
`--wuv-no-git-safe-directory` or set `WUV_DISABLE_GIT_SAFE_DIRECTORY=1`.
To disable the setuptools_scm / `vcs_versioning` workaround, use
`--wuv-no-ignore-dubious-owner` or set `WUV_IGNORE_DUBIOUS_OWNER=0`.

## Requirements

- WSL must be installed and active.
- A Windows `python.exe` and `uv.exe` must already exist.
- PowerShell (`pwsh.exe` or `powershell.exe`) must be available; the scripts will find it automatically.

## Installation

From the project root, run:

```bash
./install              # installs to $HOME/.local/bin by default
./install /custom/path # optional prefix
```

Alternatively, you can install with this one-liner:

```bash
tmpdir=$(mktemp -d) && git clone https://github.com/BartSte/wslpy "$tmpdir/wslpy" && (cd "$tmpdir/wslpy" && ./install) && rm -rf "$tmpdir"
```

The installer writes to `$HOME/.local/bin` by default and does not require root for that location. Pass another prefix if you have privileges there. Ensure that the chosen `bin` directory is on your `PATH` so that `wpy` and `wuv` are available in your shell.

The `install` script copies every executable found in the repository’s `bin/` directory (for example, `wpy`, `wuv`, `wbash`, `wpym`, and any others) into the target `bin` directory.

## Uninstallation

To remove the tools, run `./uninstall [PREFIX]` from the project root (defaulting to `$HOME/.local`). The `uninstall` script removes the same set of executables that were installed from the repository’s `bin/` directory within the chosen prefix.
