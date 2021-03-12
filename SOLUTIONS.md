

# Solutions

Solutions to the rebasing exercises, all done in the `dev-1alice/` directory:

- Switch the order of commits `04-fourth` and `05-fifth`
   - Start with `git rebase -i HEAD~5`, switch the lines with those two commits, then save the file. You're done!
   - Graphs:
      - <a href="img/01-Switch 04 and 05.png">After switching 04 and 05</a>
      - <a href="img/02-Switch 04 and 05 Merged.png">After merging in branch2</a>

- Merge the changes of `branch2` into `main` but NOT the changes of `branch1`
   - Start in `branch2` with `git checkout branch2`
   - Now do `git rebase -i HEAD~8`, remove the two commits from `branch1`, save the file
   - `git checkout main`
   - `git merge branch2`
   - That's it, you're done!  Verify with `git log --pretty=oneline`.
   - Graphs:
      - <a href="img/05-Merge just branch2.png">During the middle of rebasing</a>
      - <a href="img/06-Merge just branch2 Merged.png">After merging just branch2</a>

- Squash the two commits in `branch1` then push to `origin`
   - Check out the branch: `git checkout branch1`
   - Rebase the branch and squash the final commit into the previous one, so `branch1` only has one commit.
   - Push with `git push --force-with-lease`
   - Verify by changing into `../repo.git` and running `git log --pretty=oneline branch1`
   - Graphs:
      - <a href="img/07-Squash Branch1 Commits.png">Branch1 after both commits have been squashed</a>

- Switch the order of commits `04-fourth and 05-fifth`, push to `origin`
   - Start with `git rebase -i HEAD~5`, switch the lines with those two commits, then save the file.
   - There are two ways to do this:
      - `git pull && git push`
         - This is the preferred way, and will cause your (re-written) history to be merged in with what's in `origin`.
      - `git push --force-with-lease`
         - This will overwrite what's in `origin` and is only recommended if you are in a branch that only you work on.
         - The difference between `--force-with-lease` versus `--force` is that the latter will overwrite the remote with your changes.  `--force-with-lease` requires that you have the most recent commit (the HEAD) from the remote, to ensure that you don't overwrite changes which were checked in since your last `pull`.  This makes it safer, or at least less unsafe.
   - Verify by changing into `../repo.git` and running `git log --pretty=oneline`
   - Graphs:
      - <a href="img/08-Delete 04.png">After 04 has been deleted (removed from main)</a>
      - <a href="img/09-Delete 04 and Merged It Back.png">After 04 has been merged back in to main</a>

- Switch the order of commits `01-first-will-conflict` and `02-second-will-conflict`, THEN push to `origin`
   - Start with `git rebase -i HEAD~5`, switch the lines with those two commits, then save the file.
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
   - At this point, you've now merged your changes into main, let's push them with `git push origin`.
   - That's it, you're done!
   - Verify by changing into `../repo.git` and running `git log --pretty=oneline`

- Run `git rebase -i` and delete commit `04-fourth`.  Then recover it.
   - Use `git reflog` to find the commit you removed from `main`.
   - `git show COMMIT_ID` can be used to confirm it's the commit you want.
   - `git merge COMMIT_ID` will merge that commit back into `main`
   - *Extra Credit*: Use `git rebase -i HEAD~5` to move the commit back to its original location
   - There are a few other ways as well.  Feel free to play around in Git, that's what this repo is for!
   
- Switch the order of commits `01-first-will-conflict` and `02-second-will-conflict`
   - Start with `git rebase -i HEAD~5`, switch the lines with those two commits, then save the file.
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
   - Graphs:
      - <a href="img/10-Switch 01 and 02.png">Switched 01 and 02</a>
      - <a href="img/11-Switch 01 and 02 Merged.png">After merging in branch2</a>


If the commit history for any of the above look "weird" when you're done, that's because you're rewriting history, so yeah.  The tool <a href="https://github.com/jonas/tig">tig</a> can make the history a little
clearer to read.


