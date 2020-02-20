#set -x
MyIP=`dig +short myip.opendns.com @resolver1.opendns.com`
username=`git config --get user.email`
raw_command=`echo -e "/usr/local/bin/aws ec2 authorize-security-group-ingress --group-id sg-0cebfa1c3c902e7fe --ip-permissions IpProtocol=-1,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=$MyIP/32,Description="$username"}]'"`
full_command=`echo "eval $raw_command"`
command=`echo $full_command|sed 's/eval //g'`
eval "${command}"
