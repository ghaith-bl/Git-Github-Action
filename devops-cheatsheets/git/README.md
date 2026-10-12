# Git — Core Reference (Junior DevOps)

> Core reference for daily work.
> Legend: `<x>` = replace it · `#` = comment · `⚠` = destructive · `✅` = safe/preferred

---

## 1. The 4 areas — the whole model

```
 Working Directory  →  Staging Area  →  Local Repo  →  Remote Repo
   (your files)        (git add)       (git commit)    (git push)
        ↑                                   |               |
        └────────── git restore ────────────┘               |
        └──────────────────── git pull ─────────────────────┘
```

| Area | What's there | Enter with | Leave with |
|---|---|---|---|
| Working Directory | edited files on disk | edit a file | `git add` |
| Staging Area | snapshot ready to commit | `git add` | `git commit` / `git restore --staged` |
| Local Repository | committed history (`.git/`) | `git commit` | `git push` |
| Remote Repository | the GitHub copy | `git push` | `git pull` |

**Every command below is just moving a change between two of these boxes.**

---

## 2. Setup (once per machine)

```bash
git config --global user.name "Ghaith"            # name shown on every commit
git config --global user.email "you@example.com"  # must match your GitHub email
git config --global init.defaultBranch main       # new repos start on main
git config --list                                 # check what's set
```

---

## 3. Start a repo

```bash
git init                    # turn the current folder into a repo
git clone <url>             # copy a remote repo + its history
git clone <url> <dir>       # clone into a custom folder name
```

---

## 4. The daily loop

```bash
git status                 # what changed / what's staged   ← run this constantly
git status -s              # short:  M = modified, A = added, ?? = untracked

git add <file>             # stage one file
git add .                  # stage all changes in current dir + below
git add -A                 # stage all changes in the whole repo

git commit -m "msg"        # commit what's staged
git commit --amend         # edit the LAST commit (message or content)
```

Message style (Conventional Commits):

```
feat: add ingress manifest      fix: correct probe timeout
docs: update README             chore: bump image tag
ci: add lint workflow           refactor: split deployment yaml
```

---

## 5. Look before you touch

```bash
git log --oneline              # one line per commit
git log --oneline --graph      # + branch shape        ← most used
git log -n 5                   # last 5 commits

git show <commit>              # full details of one commit

git diff                       # working dir vs staging
git diff --staged              # staging vs last commit
```

| Ref | Means |
|---|---|
| `HEAD` | the current commit |
| `HEAD~1` | one commit back |
| `HEAD~3` | three commits back |
| `abc1234` | short SHA |

---

## 6. Undo — pick by "where is the change?"

```bash
# --- still in the Working Directory (not staged) ---
git restore <file>              # throw away your edits  ⚠ unrecoverable

# --- in the Staging Area ---
git restore --staged <file>     # unstage, keep the edits

# --- in the last commit, NOT pushed yet ---
git reset --soft  HEAD~1        # undo commit, changes stay STAGED
git reset --mixed HEAD~1        # undo commit, changes stay UNSTAGED (default)
git reset --hard  HEAD~1        # undo commit + DELETE the changes  ⚠

# --- already PUSHED ---
git revert <commit>             # a new commit that reverses it  ✅ safe for teammates

# --- untracked junk ---
git clean -n                    # dry run: what would be deleted
git clean -fd                   # actually delete untracked files + folders  ⚠
```

> **Rule: `reset` before push · `revert` after push.**

Panic button:

```bash
git reflog                          # every place HEAD has been, incl. "lost" commits
git reset --hard <sha-from-reflog>  # jump back to a good state
```

---

## 7. Branches

```bash
git branch                      # list local branches (* = current)
git branch -a                   # local + remote

git switch -c feature/add-hpa   # create + switch
git switch main                 # switch to an existing branch
git switch -                    # back to the previous branch

git branch -d <name>            # delete (only if already merged)
git push origin --delete <name> # delete it on GitHub too
```

Naming: `feature/add-hpa` · `fix/crashloop-probe` · `hotfix/prod-secret`

---

## 8. Merge & conflicts

```bash
git switch main
git merge feature               # bring feature INTO main
git merge --abort               # cancel a conflicted merge and start over
```

When it conflicts, `git status` lists the files. Open one and you'll see:

```
<<<<<<< HEAD
your version (the branch you're ON)
=======
their version (the branch you're MERGING IN)
>>>>>>> feature
```

Delete the markers, keep the right content, then:

```bash
git add <file>
git commit                      # finishes the merge
```

---

## 9. Remotes (talking to GitHub)

```bash
git remote -v                                            # which remotes + URLs
git remote add origin git@github.com:<user>/<repo>.git   # link local → GitHub
git remote set-url origin <new-url>                      # fix a wrong URL

git fetch origin                # download refs, change nothing locally
git pull                        # fetch + merge into your branch

git push -u origin main         # first push (sets upstream)
git push                        # every push after that
```

URL formats:

```
git@github.com:<user>/<repo>.git          # SSH   ✅ use this when SSH keys are set up
https://github.com/<user>/<repo>.git      # HTTPS — will ask for a token
```

> Mixing an HTTPS remote with SSH keys is why you get surprise password prompts. Pick one and stay on it.

---

## 10. Small tools you'll use weekly

```bash
# Stash — park work to switch branches fast
git stash                       # save changes, clean the working dir
git stash -u                    # include untracked files
git stash list                  # see what's parked
git stash pop                   # bring the latest one back

# Tags — mark a release
git tag -a v1.0.0 -m "release 1.0"    # annotated tag on HEAD
git push origin v1.0.0                # push that tag

# Untrack a file you committed by mistake
git rm --cached <file>          # stops tracking, keeps it on disk
```

---

## 11. .gitignore

```gitignore
# secrets — never commit
*.env
*.log
node_modules/
.terraform/
*.tfstate
kubeconfig
*.pem
```

> `.gitignore` only affects **untracked** files. If Git already tracks it, run `git rm --cached <file>` first.
> Comments in `.gitignore` must be on their **own line**. `*.env   # secrets` on one line is read as one long pattern and matches nothing.

---

## 12. GitHub CLI (`gh`) — the five you need

```bash
gh auth login                                   # log in
gh auth status                                  # who am I / which scopes
gh repo create <name> --public --source=. --push
gh repo clone <user>/<repo>
gh pr create --title "t" --body "b"
```

---

## 13. "I want to…" → command

| Goal | Command |
|---|---|
| See what I changed | `git diff` |
| Unstage a file | `git restore --staged <file>` |
| Throw away my edits | `git restore <file>` |
| Fix the last commit message | `git commit --amend` |
| Undo last commit, keep the code | `git reset --soft HEAD~1` |
| Undo a commit I already pushed | `git revert <sha>` |
| Recover something I destroyed | `git reflog` |
| Park work and switch branch | `git stash` → `git switch other` |
| Delete untracked files | `git clean -fd` |
| Fix a password prompt on push | `git remote set-url origin git@github.com:u/r.git` |

---

## 14. Gotchas

- `reflog` recovers lost **commits**, not lost **edits**. `reset --hard` and `clean -fd` destroy uncommitted work permanently.
- `.gitignore` does nothing for files Git already tracks → `git rm --cached`.
- Git tracks **content**, not empty folders. Add a `.gitkeep` if you need one.
- Never commit `.env`, kubeconfig, tokens, `*.pem`. A pushed secret is a leaked secret — rotate it, don't just delete it.
- Old repos default to `master`, new ones to `main`. Check with `git branch`.
- After resolving a conflict, search for leftovers before committing: `git diff --check` or `grep -nE '^(<<<<<<<|=======|>>>>>>>)' <file>`. Deleting the `<<<` / `>>>` symbols but leaving the branch names (`HEAD`, `feature-x`) behind is an easy mistake.
- A folder with its own `.git/` inside your repo is pushed as an empty, unclickable link (embedded repo), not as files.
