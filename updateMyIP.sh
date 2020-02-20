#set -x

#Set Variables
IFS='\'
s_group="sg-0cebfa1c3c902e7fe"
FileData=`ls ./*.dados | tail -n +1`
MyIP=`cat $FileData | cut -f1 -d\;`
username=`cat $FileData | cut -f2 -d\;`

#Revoke access
user_exists=`aws ec2 describe-security-groups --group-id $s_group | grep $username`

while [ "${user_exists}" != "" ]; do 
 OldIP=`echo "$user_exists" | awk '{print $2}' | tail -1`
 aws ec2 revoke-security-group-ingress --group-id $s_group --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges="[{CidrIp=$OldIP}]"
user_exists=`aws ec2 describe-security-groups --group-id $s_group | grep $username`
done

#Authorize Access
raw_command=`echo -e "/usr/local/bin/aws ec2 authorize-security-group-ingress --group-id $s_group --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=$MyIP,Description="$username"}]'"`

full_command=`echo "eval $raw_command"`

command=`echo $full_command|sed 's/eval //g'`

eval "${command}"

#Remove cache
git rm -f $FileData
git add --all
git commit -m "Removendo arquivo $FileData"
git push https://kelweenn.praes:F6dssUxzchs76s1-1coe@gitdev.net.com.br/devops-dextra/updateMyIp-AWS.git
#git push -u origin master


