#!/bin/bash
# install node script
cd /usr/local
apt update -y
apt install telnet -y
apt install curl -y
apt install git -y
wget https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-x64.tar.xz
tar -C /usr/local --strip-components 1 -xJf node-v16.13.2-linux-x64.tar.xz
npm install -g npm@latest
npm install -g typescript
npm install -g mstr-viz
apt install python3 -y
