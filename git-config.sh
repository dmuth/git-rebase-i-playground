#!/bin/bash
#
# Set up configuration for this repo to make things a little easier
#

# Errors are fatal
set -e 


git config --local alias.st status
git config --local alias.ci commit
git config --local alias.co checkout
git config --local alias.lg "log --graph --pretty=format:'%C(yellow)%h%Creset%C(auto)%d%Creset %s %Creset'"

echo "# "
echo "# Successfully set local Git aliases:"
echo "# "
git config --list --local |grep alias

