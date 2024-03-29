#set -x

#Set Variables
IFS='\'
s_group="YOUR_SECURITY_GROUP"
FileData=`ls ./*.dados | tail -n +1`
MyIP=`cat $FileData | cut -f1 -d\;`
username=`cat $FileData | cut -f2 -d\;`

if [ "${FileData}" == "" ]; then
	echo "Nenhum arquivo de dados. Verificar"
	exit 0
fi

#Remove cache
remove_cache (){
git checkout master
git pull
git rm -f $FileData
git add --all
git commit -m "Removendo arquivo $FileData [ci skip]"
git push https://USER:PASS@YOUR_PROJECT.git -o ci.skip
#git push -u origin master
}

#Set Variables
IFS='\'
s_group="YOUR_SECURITY_GROUP"
FileData=`ls ./*.dados | tail -n +1`
MyIP=`cat $FileData | cut -f1 -d\;`
username=`cat $FileData | cut -f2 -d\;`

#Revoke access
user_exists=`/usr/local/bin/aws ec2 describe-security-groups --group-id $s_group | grep $username`
IP_exists=`echo "${user_exists}"|grep $MyIP`
if [ "${IP_exists}" != "" ]; then
	echo "IP já liberado. Saindo"
	remove_cache
	exit 0
fi

while [ "${user_exists}" != "" ]; do 
 OldIP=`echo "$user_exists" | awk '{print $2}' | tail -1`
 /usr/local/bin/aws ec2 revoke-security-group-ingress --group-id $s_group --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges="[{CidrIp=$OldIP}]"
user_exists=`/usr/local/bin/aws ec2 describe-security-groups --group-id $s_group | grep $username`
done

#Authorize Access
raw_command=`echo -e "/usr/local/bin/aws ec2 authorize-security-group-ingress --group-id $s_group --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=$MyIP,Description="$username"}]'"`

full_command=`echo "eval $raw_command"`

command=`echo $full_command|sed 's/eval //g'`

eval "${command}"

remove_cache

