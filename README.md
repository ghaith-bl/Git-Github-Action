# DevOps Cheatsheets

Quick reference for Git and GitHub Actions, scoped to what's actually used day to day.

## Files

| Topic | Reference | Exercises |
|---|---|---|
| Git | [`git/README.md`](./devops-cheatsheets/git/README.md) | [`git/EXERCISES/`](./devops-cheatsheets/git/EXERCISES/) — 10 hands-on labs |
| GitHub Actions | [`github-actions/README.md`](./devops-cheatsheets/github-actions/README.md) | [`github-actions/EXERCISES.md`](./devops-cheatsheets/github-actions/EXERCISES.md) — in progress |

Each Git lab is a small "server monitor" project built to practice one idea (staging, branching, conflicts, undo, two developers on one remote).
See the [lab index](./devops-cheatsheets/git/EXERCISES/README.md) for what each lab covers and its commit history.

## Roadmap

**Git** — each idea unlocks the next:

```
the 4 areas → add / commit → log & diff → undo → branches → merge → remotes → stash, tags, .gitignore
```

Undo is the payoff. Once the 4 areas are clear, "which undo command?" is answered by
asking where the change currently sits.

**GitHub Actions:**

```
the hierarchy → triggers → run: vs uses: → the core actions → env & secrets → if: → needs: → permissions
```

`needs:` is the payoff. Jobs run on separate machines, which is why `checkout` is
repeated in every job and why artifacts exist at all.

## Progress

| Topic | Reference read | Exercises added | Exercises done |
|---|---|---|---|
| Git | ☑ | ☑ | ☑ |
| GitHub Actions | ☐ | ☐ | ☐ |

## Conventions

- `<x>` → replace with your own value
- `#` → inline comment explaining that line
- `⚠` → destructive / irreversible
- `✅` → the safe or preferred option

## Notes

- Action versions (`@v7`, `@v6`, …) move fast. Check the GitHub Marketplace before reusing an old snippet.
- Written against: Fedora in a Podman container, Git + GitHub CLI (`gh`).
