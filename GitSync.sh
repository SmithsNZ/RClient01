echo
echo Full directory:

ls -la

if [ "$#" -eq  "0" ]
	then
		echo "Please run with commit message"
		exit
fi

echo
echo Committing local changes:

git add .
git commit -a -m $1
git push

echo
echo Fetching master and merging with local, remote wins if conflict:

git fetch origin master
git merge -s recursive -X theirs origin/master

echo
echo Showing any local files not on remote master FYI:

git clean -dn