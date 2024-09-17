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