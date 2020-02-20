MyIP=`dig +short myip.opendns.com @resolver1.opendns.com`
username=`git config --get user.email`
echo "$MyIP/32;$username" > $username.dados
