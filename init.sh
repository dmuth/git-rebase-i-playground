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

touch .initial-checkin
git add .initial-checkin
git commit -m "Initial Checkin"


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
git checkout -b $BRANCH1

commit 10-branch1
commit 11-branch1
git push --set-upstream origin branch1

echo "# "
echo "# Creating ${BRANCH2} off of ${BRANCH1}..."
echo "# "
git checkout -b $BRANCH2

commit 20-branch2
commit 21-branch2

git checkout master

commit 05-fifth
git push

echo "# "
echo "# All done!"
echo "# "
echo "# The repo in ${DEV1} is currently two branches deep, and the commit log for master looks like this:"
echo "# "
git log --pretty=oneline --graph --all

echo "# "
echo "# Don't forget about branch1 and branch2!"
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
echo "# "





