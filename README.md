
# Learn "git rebase -i" with this lab/playground

Want to learn how to **properly** use `git rebase -i` without putting your production
repo at risk?  You're in the right place!  The script included in this repo will create
a git repo (with 2 cloned copies) that has synthetic checkins and branches.  It makes
for an ideal testing ground to experiment with `git rebase -i` without going insane.


## Getting Started

- Clone this repo: `git@github.com:dmuth/git-rebase-i-playground.git`
- `cd git-rebase-i-playground`
- `./init.sh`

This will create the following directories:
- `dev1` - A clone of the repo, with two branches: `branch1` and `branch2`.  `branch1` is a branch from master while `branch2` is based on `branch1`.  That is by design (and is based on a True Story, heh).
- `dev2`- A clone of the repo, only containing `master`.
- `repo.git` - A "bare" clone of the repo.  Note that if you `cd` to this directory, commands like `git log --pretty=oneline` will work just fine. That is useful for debugging.

NOTE: Running `init.sh` will remove those directories if they already exist.  This is so that you can have a "clean slate" every time you run the script.


## Exercises

Now that you have the repos set up, here are some sample exercises to try (answers below):

- Switch the order of commits `07-seventh` and `08-eight`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`
- Merge the changes of `branch2` into `master` but NOT the changes of `branch1`
- Switch the order of commits `07-seventh and 08-eight`, THEN push to `origin`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, THEN push to `origin`




## Contact

My email is doug.muth@gmail.com.  I am also <a href="http://twitter.com/dmuth">@dmuth on Twitter</a> 
and <a href="http://facebook.com/dmuth">Facebook</a>!  Additional ways to find me <a href="http://www.dmuth.org/contact">are on my website</a>.

