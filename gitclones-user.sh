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

function repo_main() {
	repo_dir=$(echo $repo|awk -F'/' '{print $2}'|awk -F'.' '{print $1}')
	if [ -d $repo_dir ]
	then
		echo "updating $repo_dir as it already exists"
		cd $repo_dir 
		git pull 
		cd -
	else
		echo "Cloning $repo"
		git clone $repo
	fi
}

for repo in $(cat ./clones_$USER.json)
do
	repo_main "$repo" &
done
wait
echo "Cleaing up.."
rm -f ./repos_$USER.json
rm -f ./clones_$USER.json
echo "Done."
