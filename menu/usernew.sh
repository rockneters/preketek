#!/bin/bash
IP=$(wget -qO- icanhazip.com);
domain="$(cat /etc/v2ray/domain)"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
echo "Checking VPS"
clear
until [[ $Login =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Username: " -e Login
		user_EXISTS=$(grep -w $Login /etc/list-akun | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
#read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif


echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
exp1=`date -d "$masaaktif days" +"%d-%m-%Y"`

echo -e "#SSH $Login $exp1 $Pass" >> /etc/list-akun
clear
echo -e ""
echo -e "Sukses !"
echo -e "==============================" | lolcat
echo -e "    • ROCKNET STORE | VPN • "
echo -e "==============================" | lolcat
echo -e "SSH Account Configuration"
echo -e "Username       : $Login "
echo -e "Password       : $Pass"
echo -e "Aktif Sampai   : $exp1"
echo -e "==============================" | lolcat
echo -e "Server         : $ISP"
echo -e "Host           : $domain"
echo -e "OpenSSH        : 22, 500"
echo -e "Dropbear       : 143, 109"
echo -e "WS-OPENSSH     : 2086"
echo -e "WS-DROPBEAR    : 2052"
echo -e "WS-OVPN        : 2082"
echo -e "WS-SSH         : 2095"
echo -e "WS-SSH SSL/TLS : 443"
echo -e "SSL/TLS        : 444, 777"
echo -e "BadVPN/UDPGW   : 7100, 7200, 7300"
echo -e "Squid          : 3128, 8080 (limit to IP SSH)" 
echo -e "OpenVPN        : TCP 1194 http://$domain:81/client-tcp-1194.ovpn"
echo -e "OpenVPN        : UDP 2200 http://$domain:81/client-udp-2200.ovpn"
echo -e "OpenVPN        : SSL 992 http://$domain:81/client-tcp-ssl.ovpn"
echo -e "==============================" | lolcat
echo -e "Payload SSH Websocket HTTP"                                                          
echo -e "GET / HTTP/1.1[crlf]Host: $domain[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "==============================" | lolcat
echo -e "Payload SSH Websocket SSL"
echo -e "GET wss://bug [protocol][crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "==============================" | lolcat
echo -e "Terimakasih"
echo -e ""
