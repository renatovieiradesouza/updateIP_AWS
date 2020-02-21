set -x
#rm -f ./*.dados
#git add .
#git commit -m "Corrections $username"
#git push
MyIP=`dig +short myip.opendns.com @resolver1.opendns.com`
if [ "${MyIP}" == "187.32.0.50" ] || [ "${MyIP}" == "200.186.114.74" ]; then
	echo "Você já está na rede da Dextra, não precisa disso aqui!"
	exit 0
fi
username=`git config --get user.email`
echo "$MyIP/32;$username" > $username.dados
git add $username.dados
git commit -m "$username; IP: $MyIP"
git push

rm -fv $username.dados
