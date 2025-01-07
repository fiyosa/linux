# if connection internet slow on lubuntu
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
"change 3 -> 2"

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

# install nvm for nodejs
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile 

# install jenkins
wget https://get.jenkins.io/war-stable/2.361.2/jenkins.war
java -jar jenkins.war --httpPort=9090 &
"https://crontab.guru/" => for check commit git certain time