
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
- Switch the order of commits `07-seventh and 08-eight`, merge to `master`, THEN push to `origin`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, THEN push to `origin`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, merge to `master`, THEN push to `origin`


# Hints

Here are some hints to lead you in the right direction but without

- Switch the order of commits `07-seventh` and `08-eight`
   - *Make sure you are going far enough back in the revision history...*
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`
   - *You're going to have to resolve that merge conflict...*
- Merge the changes of `branch2` into `master` but NOT the changes of `branch1`
   - *You'll need to remove some commits...*
- Switch the order of commits `07-seventh and 08-eight`, merge to `master`, THEN push to `origin`
   - *You'll need to overwrite what's already there...*
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, merge to `master`, THEN push to `origin`
   - *You'll need to handle a merge conflict AND overwrite history in the origin...*


## Solutions

Solutions to the above exercises:

- Switch the order of commits `07-seventh` and `08-eight`
   - Start with `git rebase -i HEAD~10`, switch the lines with those two commits, then save the file. You're done!
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict` in the `master` branch
   - Start with `git rebase -i HEAD~11`, switch the lines with those two commits, then save the file.
   - Edit `file.txt` and resolve the conflicts
   - `git add file.txt`
      - Note that `git log` will show a VERY incomplete history at this point. That's fine--you traveled back in time.
   - `git commit`
   - Running `git status` tells you that you're not done yet, and tells you what to do next:
   - `git rebase --continue`
   - Uh oh, we have another conflict because the next commit also changes `file.txt`.
   - Edit `file.txt` and resolve the conflicts
   - `git add file.txt`
   - `git commit`
   - `git rebase --continue`
   - No more conflicts, so that's it, you're done! Verify with `git log`.
- Merge the changes of `branch2` into `master` but NOT the changes of `branch1`
   - Start with `git rebase -i HEAD~11`, remove the two commits from `branch1`, save the file
   - `git checkout master`
   - `git merge branch2`
   - That's it, you're done!  Verify with `git log --pretty=oneline`.
- Switch the order of commits `07-seventh and 08-eight`, merge to `master`, THEN push to `origin`
   - Start with `git rebase -i HEAD~10`, switch the lines with those two commits, then save the file.
   - `git checkout master`
   - `git merge branch2`
      - `git log --pretty=online` will show TWO commits with a log message of `09-ninth`, one of which is on `origin/master`.  This is fine, as history has been rewritten.  In fact, the merge from `branch2` takes this into account.
   - `git push origin master`
   - Verify by changing into `../repo.git` and running `git log --pretty=oneline`
- Switch the order of commits `03-third-will-conflict` and `04-fourth-will-conflict`, merge to `master`, THEN push to `origin`
   - Start with `git rebase -i HEAD~11`, switch the lines with those two commits, then save the file.
   - Edit `file.txt` and resolve the conflicts
   - `git add file.txt`
      - Note that `git log` will show a VERY incomplete history at this point. That's fine--you traveled back in time.
   - `git commit`
   - Running `git status` tells you that you're not done yet, and tells you what to do next:
   - `git rebase --continue`
   - Uh oh, we have another conflict because the next commit also changes `file.txt`.
   - Edit `file.txt` and resolve the conflicts
   - `git add file.txt`
   - `git commit`
   - `git rebase --continue`
   - `git checkout master`
   - `git merge branch2`
   - At this point, you've now merged your changes into master, let's push them with `git push origin`.
   - That's it, you're done!
   - Verify by changing into `../repo.git` and running `git log --pretty=oneline`



If the commit history for any of the above look "weird" when you're done, that's because you're rewriting history, so yeah.  The tool <a href="https://github.com/jonas/tig">tig</a> can make the history a little
clearer to read.


## Additional Resources

- https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase
- https://thoughtbot.com/blog/git-interactive-rebase-squash-amend-rewriting-history
- https://git-scm.com/docs/git-rebase
- https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History


## Contact

My email is doug.muth@gmail.com.  I am also <a href="http://twitter.com/dmuth">@dmuth on Twitter</a> 
and <a href="http://facebook.com/dmuth">Facebook</a>!  Additional ways to find me <a href="http://www.dmuth.org/contact">are on my website</a>.

