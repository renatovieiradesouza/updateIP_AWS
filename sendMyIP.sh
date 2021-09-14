#set -x
#rm -f ./*.dados
#git add .
#git commit -m "Corrections $username"
#git push
MyIP=`dig +short myip.opendns.com @resolver1.opendns.com`
if [ "${MyIP}" == "YOUR_NETWORK_OR_VPN" ] || [ "${MyIP}" == "YOUR_PUBLIC_IP" ]; then
	echo "Você já está na rede da sua empresa, não precisa disso aqui!"
	exit 0
fi
username=`git config --get user.email`
echo "$MyIP/32;$username" > $username.dados
git add $username.dados
git commit -m "$username; IP: $MyIP"
git push

rm -fv $username.dados
