# GitHub Actions — Core Reference (Junior DevOps)

> Core reference: what you need to read, write, and fix a normal workflow.

---

## 1. The hierarchy — the whole model

```
Event (push / PR / manual)
   └── Workflow          = one .yml file in .github/workflows/
        └── Job          = runs on ONE fresh machine
             └── Step    = one command (run:) or one action (uses:)
```

| Term | Meaning |
|---|---|
| Workflow | the whole `.yml` file |
| Event | what triggers it (`on:`) |
| Job | isolated unit on its own runner — **jobs don't share files** |
| Step | one task inside a job — steps **do** share files |
| Runner | the machine (`ubuntu-latest`) |
| Action | reusable package pulled in with `uses:` |

The file must be at this exact path, or nothing happens:

```
.github/workflows/ci.yml
```

---

## 2. Anatomy — read this once, slowly

```yaml
name: CI                              # shown in the Actions tab

on:                                   # WHEN to run
  push:
    branches: [main]                  # only pushes to main
  pull_request:                       # and every pull request

jobs:
  build:                              # job id
    runs-on: ubuntu-latest            # which machine
    timeout-minutes: 10               # kill it if it hangs (default is 6 hours!)

    steps:
      - name: Checkout code
        uses: actions/checkout@v7     # copies your repo onto the runner — needed in EVERY job

      - name: Install dependencies
        run: npm ci                   # a shell command

      - name: Run tests
        run: |                        # | = several commands
          npm run lint
          npm test
```

---

## 3. Triggers (`on:`)

```yaml
on:
  push:
    branches: [main]                  # only pushes to main
    paths-ignore: ['**.md']           # skip documentation-only commits

  pull_request:                       # every PR

  workflow_dispatch:                  # adds a manual "Run workflow" button
    inputs:
      environment:
        description: 'Target env'
        required: true
        type: choice
        options: [staging, production]

  schedule:
    - cron: '0 3 * * *'               # daily at 03:00 UTC
```

> A workflow only shows the manual button / runs on schedule if the file exists on the **default branch**.

---

## 4. Steps: `run:` vs `uses:`

```yaml
steps:
  - run: echo "hello"                 # run a shell command yourself
  - uses: actions/checkout@v7         # use someone else's published action
    with:                             # inputs for that action
      fetch-depth: 0
```

A step has one or the other. Never both.

---

## 5. The actions you'll actually use

```yaml
- uses: actions/checkout@v7            # clone the repo — always first
  with:
    fetch-depth: 0                     # 0 = full history; default 1 = last commit only

- uses: actions/setup-node@v7          # install Node + cache npm
  with:
    node-version: '22'
    cache: 'npm'

- uses: actions/setup-python@v7
  with:
    python-version: '3.12'
    cache: 'pip'

- uses: actions/upload-artifact@v7     # save files out of the run so you can download them
  with:
    name: test-report
    path: reports/
```

> ⚠ Action versions move fast (`@v4` → `@v7` in about a year). Check the Marketplace page before copying an old snippet.

---

## 6. Variables and secrets

```yaml
env:
  APP_NAME: my-api                    # available to every job

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: Use a secret
        env:
          TOKEN: ${{ secrets.API_TOKEN }}   # ✅ pass secrets through env, not inline
        run: echo "token length is ${#TOKEN}"

      - name: Set a value for LATER steps
        run: echo "IMAGE_TAG=v1.2.3" >> $GITHUB_ENV

      - name: Read it
        run: echo "$IMAGE_TAG"
```

Contexts you'll use:

| Expression | Value |
|---|---|
| `${{ github.repository }}` | `owner/repo` |
| `${{ github.ref_name }}` | `main` |
| `${{ github.sha }}` | full commit SHA |
| `${{ github.event_name }}` | `push`, `pull_request`, … |
| `${{ github.actor }}` | who triggered it |
| `${{ secrets.GITHUB_TOKEN }}` | token GitHub creates automatically |

> Secrets are hidden in logs and are **not** available to workflows from forked PRs.

---

## 7. Conditions (`if:`)

```yaml
steps:
  - name: Deploy only from main
    if: github.ref_name == 'main'
    run: ./deploy.sh

  - name: Skip on pull requests
    if: github.event_name != 'pull_request'
    run: ./publish.sh

  - name: Upload the report even when tests failed
    if: always()
    uses: actions/upload-artifact@v7
    with:
      name: report
      path: reports/

  - name: Only when something broke
    if: failure()
    run: echo "notify the team"
```

Four you need: `success()` (the default) · `failure()` · `always()` · `cancelled()`

---

## 8. Running jobs in order (`needs:`)

By default all jobs start **at the same time** on **separate machines**.

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - run: npm run lint

  test:
    needs: lint                       # wait for lint to pass first
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7     # ← needed AGAIN, this is a fresh machine
      - run: npm test
```

> Because each job is a fresh machine, a file created in `lint` does **not** exist in `test`.
> To move files between jobs, use `upload-artifact` then `download-artifact@v8`.

---

## 9. Permissions

```yaml
permissions:
  contents: read                      # read the repo — the safe default
  packages: write                     # only if you push images to ghcr.io
```

Set the minimum. Most CI workflows need nothing more than `contents: read`.

---

## 10. Full example — a normal CI workflow

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@v7
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci                   # ci = clean install straight from the lockfile
      - run: npm run lint

  test:
    needs: lint                       # only run if lint passed
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@v7
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - run: npm test

      - name: Upload test report
        if: always()                  # ✅ upload it even when tests fail
        uses: actions/upload-artifact@v7
        with:
          name: test-report
          path: reports/
```

---

## 11. Debugging

```bash
gh run list --limit 10               # recent runs
gh run view <run-id>                 # summary
gh run view <run-id> --log-failed    # only the failed step's logs   ← start here
gh run watch                         # follow a live run
gh run rerun <run-id> --failed       # retry just the failed jobs
```

Inside a workflow:

```yaml
- name: Dump everything available
  env:
    GITHUB_CONTEXT: ${{ toJSON(github) }}   # through env, same rule as secrets
  run: echo "$GITHUB_CONTEXT"
```

Repo secrets that turn on verbose logs: `ACTIONS_STEP_DEBUG = true`

---

## 12. Gotchas

- Forgetting `actions/checkout` → "no such file or directory". The #1 mistake, and it's needed in **every** job.
- Each job is a **fresh machine**. Files don't carry over → artifacts, or do it all in one job.
- YAML is indentation-sensitive: **2 spaces, never tabs**.
- `${{ }}` is substituted into the shell command *before* it runs. Never put user input or secrets directly in `run:` — pass them through `env:`.
- Default `timeout-minutes` is 360. A hung job burns 6 hours of quota. Always set it.
- Secrets are empty in workflows triggered from forked PRs.
- The workflow file must be on the **default branch** for `workflow_dispatch` and `schedule` to appear.
