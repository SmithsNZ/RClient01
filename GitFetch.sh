echo
echo Fetching master and merging with local, remote wins if conflict:

git fetch origin master
git merge -s recursive -X theirs origin/master

echo
echo Showing any local files not on remote master FYI:

git clean -dn