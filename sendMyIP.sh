set -x
	rm -f ./*.dados
	git add .
	git commit -m "Corrections $username"
	git push
MyIP=`dig +short myip.opendns.com @resolver1.opendns.com`
username=`git config --get user.email`
echo "$MyIP/32;$username" > $username.dados
git add $username.dados
git commit -m "$username; IP: $MyIP"
git push

rm -fv $username.dados
