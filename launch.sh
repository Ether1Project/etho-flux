#!/bin/bash

# Check that we have the env vars NODE, DUID and WALLET in place                                    
if [ -z "$WALLET" ]                                                                                 
then                                                                                                
        echo "\$WALLET is empty. Make sure you define the environment variable."                    
        exit;                                                                                       
fi                                                                                                  
if [ -z "$DUID" ]                                                                                        
then                                                                                                      
        echo "\$DUID is empty. Make sure you define the environment variable."                            
        exit;                                                                                             
fi                                                                                                        
if [ -z "$NODE" ]                                                                                         
then                                                                                                      
        echo "\$NODE is empty. Make sure you define the environment variable."                            
        exit;                                                                                             
fi                                                                                                        


sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/geth
/usr/sbin/geth --ethofs=$NODE --ethofsUser=$DUID --ethofsWallet=$WALLET --ethofsInit
sleep 3
/usr/sbin/geth --ethofs=$NODE --ethofsUser=$DUID --ethofsWallet=$WALLET --ethofsConfig
sleep 3
echo "[program:geth]" > ether1node
echo "command=/usr/sbin/geth --ethofs=$NODE --ethofsUser=$DUID --ethofsWallet=$WALLET" >> ether1node
echo "autostart=true" >> ether1node
echo "autorestart=true" >> ether1node
echo "user=ether1node" >> ether1node
echo "stderr_logfile=/var/log/geth.err.log" >> ether1node
echo "stdout_logfile=/var/log/geth.out.log" >> ether1node
echo "environment=HOME=/home/ether1node,USER=ether1node" >> ether1node
echo "[unix_http_server]" > supervisor.conf
echo "file=/var/run/supervisor.sock   ; (the path to the socket file)" >> supervisor.conf
echo "chmod=0700                       ; sockef file mode (default 0700)" >> supervisor.conf
echo "" >> supervisor.conf
echo "[supervisord]" >> supervisor.conf
echo "logfile=/var/log/supervisord.log ; (main log file;default $CWD/supervisord.log)" >> supervisor.conf
echo "pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)" >> supervisor.conf
echo "childlogdir=/var/log/            ; ('AUTO' child log dir, default $TEMP)" >> supervisor.conf
echo "" >> supervisor.conf
echo "rpcinterface:supervisor]" >> supervisor.conf
echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> supervisor.conf
echo "" >> supervisor.conf
echo "[supervisorctl]" >> supervisor.conf
echo "serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket" >> supervisor.conf
echo "" >> supervisor.conf
echo "[include]" >> supervisor.conf
echo "files = /etc/supervisor/conf.d/*.conf" >> supervisor.conf
echo "" >> supervisor.conf
sudo mv supervisor.conf /etc/supervisord.conf
sudo chmod 0755 /etc/supervisord.conf

chmod +x ether1node
if [ ! -d "/etc/supervisor" ]                                                                             
then                                                                                                      
        sudo mkdir /etc/supervisor/                                                                       
fi                                                                                                        
if [ ! -d "/etc/supervisor/conf.d" ]                                                                     
then                                                                                                      
        sudo mkdir /etc/supervisor/conf.d                                                                 
fi                                                                                                        


sudo mv ether1node /etc/supervisor/conf.d/geth.conf


sudo supervisord --configuration /etc/supervisord.conf
