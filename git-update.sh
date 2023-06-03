#!/bin/bash



org_dir=$(pwd)
cd $org_dir


echo "Updating git repos.."

dirs_path=$(ls -D)

for dir in $dirs_path
do
    echo $dir
    cd $dir
    echo "Running git pull"
    git pull
    cd $org_dir
done

