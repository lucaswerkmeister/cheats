#!/bin/sh
if [ "$SHELL" != "/bin/bash" ]; then
    read -p "Your shell does not appear to be `bash`; are you sure you want to install 'cheats'? [y/N]$PS2";
    if [ "$REPLY" != "y" -a "$REPLY" != "Y" ]; then
	exit;
    fi
fi
mkdir -p ~/bin
cp cheats.sh ~/bin
cp -r cheats ~/.cheats
echo -e "\n\nsource ~/bin/cheats.sh" >> ~/.bashrc
