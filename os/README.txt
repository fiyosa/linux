# if connection internet slow on lubuntu
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
"change 3 -> 2"

# test connection & check server
https://bench.sh/
wget -qO- bench.sh | bash
curl -Lso- bench.sh | bash

# test connection
ping -c 4 google.com

# Custom aliases
sudo vim ~/.bashrc
# example alias
alias k='kubectl'
# exit vim
source ~/.bashrc

# install openSSH
sudo apt update
sudo apt install openssh-server

# check port listener
netstat -anp --inet

# file manager / file explorer
ranger

# disk usage analyzer
ncdu
# speedtest internet
speedtest-cli --simple
# check all storage
df -h
# check real size file
du -sh your-file.txt
# preview web in terminal
xdg-open <URL>

# check ram & memory
htop

# displays information about your system
screenfetch

# view IP address
hostname -I

# share folder vmware
vmware-hgfsclient # check name sharing folder 
sudo nano /etc/fstab
vmhgfs-fuse    /mnt/hgfs    fuse    defaults,allow_other    0    0
{exit}
sudo mkdir /mnt/hgfs
sudo mount -a
cd /mnt/hgfs

# ==============================================================

# new line on command terminal
nano ~/.bashrc
## change all: PS1='...\w...'
PS1='...\w\n...'
exit
source ~/.bashrc

PS1="\[\e[1;32m\]┌──(\u@\h)-[\[\e[1;36m\]\w\[\e[1;32m\]]\n└─\[\e[m\]\$ "

# ==============================================================

# configuration firewall 

# list port
sudo ufw status verbose

# add rule port
sudo ufw allow in 22/tcp

# delete rule port
sudo ufw delete 9090

# block rule port
sudo ufw deny 9090

# restart 
sudo ufw reload

# block spesific ip
sudo ufw deny from 192.168.234.161 to any port 9090

# ==============================================================

# run script after reboot
touch ~/startup.sh
crontab -e 
@reboot ~/startup.sh
chmod 755 ~/startup.sh

# ==============================================================

# install nvm for nodejs
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile 

# ==============================================================

# install php and switch version
sudo apt install -y lsb-release apt-transport-https ca-certificates
sudo wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update
# if you want install composer then skip install php8.4
sudo apt install -y php8.4 

sudo update-alternatives --config php

# ==============================================================

# install composer
sudo apt install php-cli unzip curl -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version
sudo apt install -y php-mbstring php-xml php-curl php-sqlite3 php-mysql php-pgsql

# ==============================================================

# install neovim / nvim
- install git & nodejs
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
sudo apt install fzf ripgrep
nvim -v
- edit: theme & visile file

# install font (optional but exists bugs)
cd downloads 
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p ~/.local/share/fonts
cp JetBrainsMono/*.ttf ~/.local/share/fonts
fc-cache -fv
fc-list | grep "Nerd Font"

# ==============================================================

# install jenkins
wget https://get.jenkins.io/war-stable/2.361.2/jenkins.war
java -jar jenkins.war --httpPort=9090 &
"https://crontab.guru/" => for check commit git certain time