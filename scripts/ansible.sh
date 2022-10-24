#!/bin/bash

echo -e "\nInstalling ansible"

OS=""
       

# Check the operating system and set the global var. 
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo -e "\tlinux"
        OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo -e "\tmacos"
        OS="mac"        
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
        echo "bsd"
else
        # Unknown.
        echo "unknown"
fi


# Depending on the OS install the toolset
if [[ $OS == "linux" ]]
then
    echo "installing tools for linux"
    # install brew

    if ! command -v brew &> /dev/null
    then
        echo "brew could not be found"
        
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       sudo apt-get install build-essential
    fi

    #install kubectl
    if ! command -v kubectl &> /dev/null
    then
        echo "kubectl could not be found"
        brew install kubectl
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       sudo apt-get install build-essential
    fi





else
    echo "installing tools for mac"
    fi