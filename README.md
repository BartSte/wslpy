# wslpy

Bash executables that allow you to work with Python on Windows from a WSL environment.

## Description

`wpy` and `wuv` let you invoke Windows Python and uv.exe while working inside WSL. `wpy` reads the `WPY` environment variable, and `wuv` delegates to the Windows `uv.exe` executable. For example: `/mnt/c/Users/BartSte/AppData/Roaming/uv/python/cpython-3.13.7-windows-x86_64-none/python.exe`.

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