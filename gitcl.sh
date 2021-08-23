# To clone my repo
gitArray=("git@github.com:AS-Labs/dont_sleep_lock.git" "git@github.com:AS-Labs/myWeb-3aqar.git" "git@github.com:AS-Labs/dotfiles.git" "git@github.com:AS-Labs/BotterOtter.git" "git@github.com:AS-Labs/learning-tutorials.git" "git@github.com:AS-Labs/c_code_course.git" "git@github.com:AS-Labs/download-knet.git" "git@github.com:AS-Labs/web3aqar.git" "git@github.com:AS-Labs/3aqar.git" "git@github.com:AS-Labs/UN_AUTO.git" "git@github.com:AS-Labs/web-monitoring-dashboard.git" "git@github.com:AS-Labs/imperial_books.git" "git@github.com:AS-Labs/czipfile_py3.git" "git@github.com:AS-Labs/Proj_Webscraper.git" "git@github.com:AS-Labs/Countdown-react-r.git" "git@github.com:AS-Labs/Py-loop.git" "git@github.com:AS-Labs/hello-world.git")

echo " Cloning repos for AS-Labs"
for i in "${gitArray[@]}"
do 
	echo "starting clone for $i "
	git clone $i
done
echo " Job completed "
