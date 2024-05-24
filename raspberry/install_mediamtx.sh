#!/bin/bash

cd ~/fpv-lawn-mover/raspberry
wget https://github.com/bluenviron/mediamtx/releases/download/v1.8.2/mediamtx_v1.8.2_linux_arm64v8.tar.gz
tar -xvzf mediamtx_v1.8.2_linux_arm64v8.tar.gz
rm mediamtx_v1.8.2_linux_arm64v8.tar.gz

nano mediamtx.yml