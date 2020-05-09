
# Learn "git rebase -i" with this lab/playground

Want to learn how to **properly** use `git rebase -i` (also known as an interactive rebase) without putting your production
repo at risk?  You're in the right place!  The script included in this repo will create
a git repo (with 2 cloned copies) that has synthetic checkins and branches.  It makes
for an ideal testing ground to experiment with `git rebase -i` without going insane.


## Getting Started

- Clone this repo: `git@github.com:dmuth/git-rebase-i-playground.git`
- `cd git-rebase-i-playground`
- `./init.sh`

This will create the following directories:
- `dev1` - A clone of the repo, with two branches: `branch1` and `branch2`.  `branch1` is a branch from master while `branch2` is based on `branch1`.  That is by design (and is based on a True Story, heh).
   - `branch2` will be the current branch checked out.
- `dev2`- A clone of the repo, only containing `master`.
- `repo.git` - A "bare" clone of the repo.  Note that if you `cd` to this directory, commands like `git log --pretty=oneline` will work just fine. That is useful for debugging.

NOTE: Running `init.sh` will remove those directories if they already exist.  This is so that you can have a "clean slate" every time you run the script.


## Why would you want to use `git rebase -i`?

Running `git rebase -i &lt;commit_id&gt;` will bring up recent commits in the system editor and allow
you to reorder the commits, edit the commit message, or even delete commits.

Why would you want to delete a commit?  Sometimes you realize several changes after a commit that you
didn't want to make that change.  Or perhaps you made a feature branch based on another branch, and want
to deploy the changes from that feature branch but not the branch it's based on. (Happened to me, once)

### Any caveats?

Anytime you rebase, you are *rewriting history*.  If you changes have already been pushed, you will
need to push them again, and history will be overwritten.  If other users have already checked out
the branch in question, this will cause a merge on their end, which will (eventually) wind up on 
the server's repo, and in your repo.  It will make the commit history just slightly uglier.


## Exercises

Once that you have the repos set up, here are some sample exercises to try (answers below):

- Switch the order of commits `07-seventh` and `08-eight`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`
- Merge the changes of `branch2` into `master` but NOT the changes of `branch1`
- Switch the order of commits `07-seventh and 08-eight`, THEN push to `origin`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, THEN push to `origin`


# Hints

Here are some hints to lead you in the right direction but without

- Switch the order of commits `07-seventh` and `08-eight`
   - *Make sure you are going far enough back in the revision history...*
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`
   - *You're going to have to resolve that merge conflict...*
- Merge the changes of `branch2` into `master` but NOT the changes of `branch1`
   - *You'll need to remove some commits...*
- Switch the order of commits `07-seventh and 08-eight`, THEN push to `origin`
   - *You'll need to overwrite what's already there...*
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, THEN push to `origin`
   - *You'll need to handle a merge conflict AND overwrite history in the origin...*




## Contact

My email is doug.muth@gmail.com.  I am also <a href="http://twitter.com/dmuth">@dmuth on Twitter</a> 
and <a href="http://facebook.com/dmuth">Facebook</a>!  Additional ways to find me <a href="http://www.dmuth.org/contact">are on my website</a>.

