#!/bin/bash
#
# Create our Git repo, popupate it, and clone into a bare repo and a copy
#

set -e

DEV1="dev1"
DEV2="dev2"
REPO="repo.git"
FILE="file.txt"
BRANCH1="branch1"
BRANCH2="branch2"

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

#git log --pretty=oneline # Debugging
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

echo "# Switching back to ${DEV1}..."
pushd $DEV1 > /dev/null


echo "# "
echo "# Creating ${BRANCH1}..."
echo "# "
git co -b $BRANCH1
for LINE in 10-branch1 11-branch1
do
	echo $LINE >> ${LINE}.txt
	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null
done

echo "# "
echo "# Creating ${BRANCH2} off of ${BRANCH1}..."
echo "# "
git co -b $BRANCH2
for LINE in 20-branch2 21-branch2
do
	echo $LINE >> ${LINE}.txt
	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null
done

echo "# "
echo "# All done!"
echo "# "
echo "# The repo in ${DEV1} is currently two branches deep, and the commit log looks like this:"
echo "# "
git log --pretty=oneline # Debugging

echo "# "
echo "# To get started, drop into that directory with:"
echo "# "
echo "# cd ${DEV1}/"
echo "# "
echo "# Some exercises to try with git rebase -i, in increasing difficulty:  "
echo "# "
echo "# - Switch the order of commits 07-seventh and 08-eight"
echo "# - Switch the order of commits 03-third-will-conflict and 04-fourth-will-conflict"
echo "# - Merge the changes of ${BRANCH2} into master but NOT the changes of ${BRANCH1}"
echo "# - Switch the order of commits 07-seventh and 08-eight, THEN push to origin"
echo "# - Switch the order of commits 03-third-will-conflict and 04-fourth-will-conflict, THEN push to origin"
echo "# "
echo "# "





