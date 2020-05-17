#!/bin/bash
#
# Create our Git repo, popupate it, and clone into a bare repo and a copy
#

set -e

DEV1="dev-alice"
DEV2="dev-bob"
REPO="repo.git"
FILE="file.txt"
BRANCH1="branch1"
BRANCH2="branch2"

echo "# Cleaning up any past installs..."
rm -rfv $DEV1 $DEV2 $REPO > /dev/null

echo "# Creating initial copy of archive in ${DEV1}..."
mkdir -p $DEV1

pushd $DEV1 > /dev/null

git init >/dev/null

touch .initial-checkin
git add .initial-checkin
git commit -m "Initial Checkin" >/dev/null 2>/dev/null


#
# Write a commit that will conflict
#
function commit_will_conflict() {

	LINE="${1}-will-conflict"

	echo $LINE >> $FILE
	echo $LINE >> ${LINE}.txt

	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null

} # End of commit_will_conflict()


#
# Write a commit that won't conflict.
#
function commit() {

	LINE=$1

	echo $LINE >> ${LINE}.txt
	git add ${FILE} ${LINE}.txt
	git commit -m "${LINE}" > /dev/null

}


commit_will_conflict 01-first
commit_will_conflict 02-second

commit 03-third
commit 04-fourth

popd > /dev/null

echo "# Cloning bare repo to ${REPO}..."
git clone --bare $DEV1 $REPO >/dev/null 2>/dev/null

pushd $REPO > /dev/null
git remote remove origin

popd > /dev/null

echo "# Fixing origin in ${DEV1}..."
pushd $DEV1 > /dev/null

git remote add origin ../${REPO} >/dev/null 2>/dev/null
git fetch >/dev/null 2>/dev/null
git branch --set-upstream-to=origin/master master >/dev/null 2>/dev/null

popd >/dev/null

echo "# Cloning to ${DEV2}..."

git clone ${REPO} ${DEV2} >/dev/null 2>/dev/null

echo "# Switching back to ${DEV1}..."
pushd $DEV1 > /dev/null


echo "# Creating ${BRANCH1}..."
git checkout -b $BRANCH1 >/dev/null 2>/dev/null

commit 10-branch1
commit 11-branch1
git push --set-upstream origin branch1 >/dev/null 2>/dev/null

echo "# Creating ${BRANCH2} off of ${BRANCH1}..."
git checkout -b $BRANCH2 2>/dev/null

commit 20-branch2
commit 21-branch2

git checkout master >/dev/null 2>/dev/null

commit 05-fifth
git push 2>/dev/null

echo "# "
echo "# The repo in ${DEV1} is currently two branches deep, and the commit log for master looks like this:"
echo "# "
git log --pretty=oneline --graph --all

echo "# "
echo "# To get started, drop into that directory with:"
echo "# "
echo "# cd ${DEV1}/"
echo "# "
echo "# Some exercises to try with git rebase -i, in increasing difficulty:  "
echo "# "
echo "# - Switch the order of commits 04-fourth and 05-fifth"
echo "# - Switch the order of commits 01-first-will-conflict and 02-second-will-conflict"
echo "# - Merge the changes of branch2 into master but NOT the changes of branch1"
echo "# - Squash the two commits in branch1 then push to origin"
echo "# - Switch the order of commits 04-fourth and 05-fifth, push to origin"
echo "# - Switch the order of commits 01-first-will-conflict and 02-second-will-conflict, THEN push to origin"
echo "# - Run git rebase -i and delete commit 05-fifth.  Then recover it."
echo "# "



