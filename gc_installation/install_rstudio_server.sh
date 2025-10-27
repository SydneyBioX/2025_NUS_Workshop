# /bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install git

sudo apt-get install r-base
sudo apt-get install gdebi-core

wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb

sudo gdebi rstudio-server-2025.09.1-401-amd64.deb

