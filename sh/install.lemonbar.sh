#!/usr/bin/env sh

set -u -e -x
sudo apt-get install \
	libxcb1 libxcb1-dev \
	libxft2 libxft-dev \
	libx11-xcb-dev libx11-xcb1 libx11-6 libx11-dev \
	libxcb-randr0 libxcb-randr0-dev \
	libxrandr-dev libxrandr2 \
	libxcb-xinerama0 libxcb-xinerama0-dev \
	 || :
