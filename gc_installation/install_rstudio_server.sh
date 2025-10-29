# /bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install git

echo "deb [signed-by=/usr/share/keyrings/cran_debian_key.gpg] https://cloud.r-project.org/bin/linux/debian bookworm-cran40/" \
  | sudo tee /etc/apt/sources.list.d/cran.list


gpg --keyserver keyserver.ubuntu.com --recv-key B8F25A8A73EACF41
gpg --export B8F25A8A73EACF41 | sudo gpg --dearmor -o /usr/share/keyrings/cran_debian_key.gpg
sudo chmod 644 /usr/share/keyrings/cran_debian_key.gpg

# 3) Sanity-check the keyring now contains a key
gpg --no-default-keyring --keyring /usr/share/keyrings/cran_debian_key.gpg --list-keys

# 4) Update & install R
sudo apt clean
sudo apt update
sudo apt install -y r-base r-base-dev


sudo apt-get install gdebi-core

wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb

sudo gdebi rstudio-server-2025.09.1-401-amd64.deb



