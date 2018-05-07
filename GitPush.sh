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
git commit -m $1
git push