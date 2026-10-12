# Git — Labs

Hands-on labs for the [Git reference](../README.md). Each one is a tiny "server monitor" project built to practice one idea.

Every lab started as its own repo. They were imported here with their full history, so each commit keeps its original date and message.

| # | Lab | What it practices |
|---|---|---|
| 1 | [`git-repo-lab1`](./git-repo-lab1/) | First repo: `init` → `add` → `commit` → `push` to GitHub |
| 2 | [`git-repo-lab2`](./git-repo-lab2/) | Small commits, and committing a file-mode change (`chmod +x`) |
| 3 | [`git-architcture-exam1`](./git-architcture-exam1/) | The 4 areas end to end: working dir → staging → local repo → remote |
| 4 | [`git-architcture-lab2`](./git-architcture-lab2/) | The staging area: changes staged but not committed yet |
| 5 | [`git-branching-lab`](./git-branching-lab/) | Branches, two merges, resolving a log-level conflict |
| 6 | [`git-three-way-lab`](./git-three-way-lab/) | Three-way merge with a conflict on the same line |
| 7 | [`git-three-way-lab2`](./git-three-way-lab2/) | Three-way merge conflict, then cleaning the file after the merge |
| 8 | [`git-undo-lab`](./git-undo-lab/) | Undoing a commit safely with `git revert` |
| 9 | [`server-monitor-test`](./server-monitor-test/) | Developer 1: clone of a shared remote, working on `main` |
| 10 | [`server-monitor-developer2`](./server-monitor-developer2/) | Developer 2: same remote, pushes a `feature/add-disk-check` branch |

`server-monitor-test` and `server-monitor-developer2` are two clones of the same remote, used to simulate two people working on one project.

---

## See a lab's history

On GitHub: open the lab folder → **History**.

Locally:

```bash
git log --oneline --graph --full-history --simplify-merges -- devops-cheatsheets/git/EXERCISES/<lab>
```
