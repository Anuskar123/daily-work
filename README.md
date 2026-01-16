# Dissertation Daily Heartbeat

This repo is wired with a daily GitHub Actions job that appends a timestamped heartbeat entry to `notes.md`, commits, and pushes it. Use it to keep an activity streak alive without manual clicks.

## How it works
- Workflow runs once per day via cron (default: 12:00 UTC) and is also triggerable manually.
- It appends the current UTC timestamp to `notes.md`, then commits with message `chore: daily heartbeat` and pushes.
- It uses the built-in `GITHUB_TOKEN` to push to the same repo. No PAT needed unless your repo permissions are restricted.

## Configure
- Branch: set repo variable `BRANCH_NAME` to override the target branch (defaults to the checked-out branch).
- Author: optionally set repo variables `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL`; otherwise it uses `Daily Bot` / `actions@github.com`.
- Schedule: edit the cron in `.github/workflows/daily-heartbeat.yml` if you want a different time or cadence.

## Files
- `notes.md`: receives one new line per run with the UTC timestamp.
- `.github/workflows/daily-heartbeat.yml`: the automation workflow.
