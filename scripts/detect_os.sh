#!/bin/bash

echo "---------------------"
echo "\nDetecting your OS"

OS=""
     
# Check the operating system and set the global var. 
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
        OS="Linux detected"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "MacOS detected"
        OS="macos"        
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "cygwin"
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "msys"
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        echo "win"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "BSD detected"
else
        # Unknown.
        echo "unknown OS detected"
fi


# Depending on the OS install the toolset
if [[ $OS == "macos" ]]
then
    echo $OS > .os.txt
    sw_vers -productVersion  > .os_version.txt
fi


# Depending on the OS install the toolset
if [[ $OS == "linux" ]]
then
    echo "installing tools for linux"
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        ...
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    echo $OS > .os.txt
    echo $VER > .os_version.txt
else
    echo "installing tools for mac"
fi
