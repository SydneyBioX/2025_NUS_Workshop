#!/bin/bash

## docker run -e PASSWORD=pushu -e ROOT=TRUE -p 8787:8787 532cb5cec05a
sudo apt-get update
sudo apt-get install libjpeg-dev

#needed by the velocity R package 
#sudo apt-get install -y libboost-dev 
#sudo apt-get install -y libboost-all-dev
## sudo apt-get -y install r-base-dev

## Make a tmp folder and git clone
mkdir /home/gittmp/
git clone https://github.com/SydneyBioX/2025_CUHK_workshop.git /home/gittmp/

## wget all data files from Google Cloud Storage into /home/CPC/
cd /home/gittmp
## need to edit this link later, when we get the data
wget -O data.zip "https://www.dropbox.com/scl/fi/92h9jd23kxz7i62op2a5u/data.zip?rlkey=ycncox2mmds8555nps0z2p0t3&st=dvywivsn&dl=0"
unzip data.zip

ls /home/
ls /home/gittmp/
  
## Set up users
  
sudo groupadd trainees

for((userIndex = 1; userIndex <= 30; userIndex++))
  do
{
  userID=user${userIndex}
  sudo useradd -g trainees -d /home/$userID -m -s /bin/bash $userID
  # sudo cp -r /home/gittmp/* /home/$userID/
  echo $userID:2025 | sudo chpasswd
}
done
