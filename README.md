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
./install.sh              # installs to $HOME/.local/bin by default
./install.sh /custom/path # optional prefix
```

Alternatively, you can install with this one-liner:

```bash
tmpdir=$(mktemp -d) && git clone https://github.com/BartSte/wslpy "$tmpdir/wslpy" && (cd "$tmpdir/wslpy" && ./install) && rm -rf "$tmpdir"
```

The installer writes to `$HOME/.local/bin` by default and does not require root for that location. Pass another prefix if you have privileges there. Ensure that the chosen `bin` directory is on your `PATH` so that `wpy` and `wuv` are available in your shell.

## Usage

Use `wpy --help` and `wuv --help` for detailed options. `wuv` forwards all remaining arguments directly to the Windows `uv.exe`.

## Configuration

`wpy` and `wuv` are configured via the following environment variables:

- `WPY`: the `python.exe` that is used by `wpy` and `uv`. See the example in the [Description](#description) above.
- `WVENV`: the path to the virtual environment that `uv` uses. If the venv does not exist, it will be created. For example: `/mnt/c/Users/BartSte/venvs/some_venv`. This path must be located in the Windows file system. When not set, `uv` uses `WPY`.
- `WUV_CONFIG_FILE`: The `uv` config file to use. If not set, `UV_CONFIG_FILE` is used.

## Example workflow

Personally, I use `wpy` and `wuv` to develop all my Python projects from WSL, even those that only run on Windows. When I want to execute the Windows build, `wpy` and `wuv` let me run `python.exe` and `uv.exe` seamlessly.

```bash
# .bashrc or .zshrc

# Helper to read Windows environment variables
_winenv() {
    (cd /mnt/c && /mnt/c/Windows/System32/cmd.exe /d /c "echo %${1}%") | tr -d '\r'
}

if grep -iq "microsoft" /proc/version; then
    export WPY WVENV

    # Set WPY to a python.exe that is managed by uv.
    appdata=$(wslpath "$(_winenv APPDATA)")
    WPY="$appdata/uv/python/cpython-3.13.7-windows-x86_64-none/python.exe"

    # The %USERPROFILE%\venvs directory contains venvs created by uv with the name of the current directory.
    name="$(basename "$PWD")"
    whome=$(wslpath "$(_winenv USERPROFILE)")
    WVENV="$whome/venvs/$name"
fi
```

After sourcing the above, you can cd to your project and call `wuv sync`. This creates a new venv in `%USERPROFILE%\venvs` with the name of the current directory. When you want to run your project, call `wuv run <entry point>`. If you need the Python interpreter, use `wpy`. To run tests, execute `wuv run pytest`.
