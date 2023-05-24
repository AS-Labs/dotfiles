#!/bin/bash
if [[ -z "$1" ]]
then
	echo "Please enter the username"
	echo "Exiting"
	exit 1
fi
USER=$1
curl -X GET https://api.github.com/users/$USER/repos > ./repos_$USER.json

grep 'ssh_url' ./repos_$USER.json |awk '{print $2}'|tr -d '"'|tr -d ',' > ./clones_$USER.json


for repo in $(cat ./clones_$USER.json)
do
	echo "Cloning $repo"
	git clone $repo
done
echo "Cleaing up.."
rm -f ./repos_$USER.json
rm -f ./clones_$USER.json
echo "Done."
