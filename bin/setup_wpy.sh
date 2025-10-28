#!/usr/bin/env bash
#
# Description:
#   This script sets up environment variables for a Python virtual environment
#   located in the user's Windows home directory (through WSL).
#
#   Source this script from within a project directory. The script automatically determines
#   the project name based on the current directory.
#
# Variables:
#   WIN_HOME_DIR               – Must be defined before calling this script.
#   WIN_VENV_DIR               - Must be defined before calling this script
#   WIN_VENV                   – Path to the Python virtual environment for the current project.
#   WIN_PY                     – Path to the Python executable inside the virtual environment.
#

# Get the current directory name (used as the project name)
name="$(basename "$(pwd)")"

# Check if WIN_HOME_DIR is set
if [ -z "$WIN_HOME_DIR" ]; then
    echo "Error: WIN_HOME_DIR is not set."
    echo "Please export it before running this script, e.g.:"
    echo "  export WIN_HOME_DIRECTORY=/mnt/c/Users/<YourWindowsUser>"
    exit 1
fi

# Check if WIN_VENV_DIR is set
if [ -z "$WIN_VENV_DIR" ]; then
    echo "Error: WIN_VENV_DIR is not set."
    echo "Please export it before running this script, e.g.:"
    echo "  export WIN_VENV_DIRECTORY=/mnt/c/Users/MyUser/venvs"
    exit 1
fi

# Define the virtual environment and Python executable paths
export WIN_VENV="$WIN_VENV_DIR/$name"
export WIN_PY="$WIN_VENV/Scripts/python.exe"
