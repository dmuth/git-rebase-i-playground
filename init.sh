#!/bin/bash
#
# Create our Git repo, popupate it, and clone into a bare repo and a copy
#

set -e

DEV1="dev1"
DEV2="dev2"
REPO="repo.git"
FILE="file.txt"

echo "# "
echo "# Cleaning up any past installs..."
echo "# "
rm -rfv $DEV1 $DEV2 $REPO > /dev/null

echo "# "
echo "# Creating initial copy of archive in ${DEV1}..."
echo "# "
mkdir -p $DEV1

pushd $DEV1 > /dev/null

git init

touch $FILE
git add $FILE
git commit -m "Initial checkin" 

#
# Add 4 checkins of a new file and a line in the text file.
# This guarantees a conflict when rebasing any of these commits.
#
for LINE in 01-first 02-second 03-third 04-fourth 
do
	LINE="${LINE}-will-conflict"
	echo $LINE >> $FILE
	echo $LINE >> ${LINE}.txt
	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null
done


#
# Create 5 more checkins that *won't* cause conflicts.
#
for LINE in 05-fifth 06-sixth 07-seventh 08-eighth 09-ninth
do
	echo $LINE >> ${LINE}.txt
	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null
done

git log --pretty=oneline
popd > /dev/null

echo "# "
echo "# Cloning bare repo to ${REPO}..."
echo "# "
git clone --bare $DEV1 $REPO

pushd $REPO > /dev/null
git remote remove origin

popd > /dev/null

echo "# "
echo "# Fixing origin in ${DEV1}..."
echo "# "
pushd $DEV1 > /dev/null

git remote add origin ../${REPO}
git fetch
git branch --set-upstream-to=origin/master master

popd >/dev/null

echo "# "
echo "# Cloning to ${DEV2}..."
echo "# "

git clone ${REPO} ${DEV2}



