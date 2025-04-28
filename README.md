# public-key-update
public key update script

This is still being setup so standby

A little script I have been working on to auto load and remove users from computers or server access.

Change Directory to install script 

cd /usr/sbin


Then we can download the script file with this command:

wget https://raw.githubusercontent.com/txlinked/public-key-update/refs/heads/main/publickeyupdate.sh

Then once the download has finished we need to make the newly downloaded script file executable. We can do this with the following command:

chmod +x publickeyupdate.sh


Then execute the script

./publickeyupdate.sh


We need to add a line to crontab -e do the script auto updates the keys every 30 minutes to one hour.

crontab -e


Add this line to the bottom

*/30 * * * * sudo /bin/publickeyupdate.sh

CTRL X y enter 


Change Directory to update SSH login

cd /etc/ssh


Now we need to edit some lines in sshd_config

sudo nano sshd_config


Change the fallowing to use ssh key login. 

Port 22 ;your port number here and dont use 22

PermitRootLogin prohibit-password

PubkeyAuthentication yes

AuthorizedKeysFile	.ssh/authorized_keys 

PasswordAuthentication no

PermitEmptyPasswords no

CTRL-X y enter
