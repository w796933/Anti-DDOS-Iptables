#!bin/bash
# I just removed all of the optional selections so this can be used in scripts.

if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

output "Installing IPTables"

if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
     apt -y install iptables
elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "cloudlinux" ]; then
     yum -y install iptables
else 
     output "Unsupported distribution. This script only supports Fedora, RHEL, CentOS, Ubuntu, and Debian."
fi 

/sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
/sbin/iptables -t mangle -A PREROUTING -f -j DROP
/sbin/iptables -N port-scanning
/sbin/iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
/sbin/iptables -A port-scanning -j DROP

(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP >> /dev/null 2>&1")| crontab -
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP >> /dev/null 2>&1")| crontab -
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP >> /dev/null 2>&1")| crontab -
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP >> /dev/null 2>&1")| crontab -
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP >> /dev/null 2>&1")| crontab -
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP >> /dev/null 2>&1")| crontab -    
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -t mangle -A PREROUTING -f -j DROP >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -N port-scanning >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN >> /dev/null 2>&1")| crontab - 
(crontab -l ; echo "@reboot /sbin/iptables -A port-scanning -j DROP >> /dev/null 2>&1")| crontab - 
