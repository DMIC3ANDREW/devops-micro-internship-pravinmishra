---
name: pr-ready
description: Produce a PR-readiness report for the currently staged changes — summary, risks, and a drafted PR title/description. Read-only; never mutates repository state.
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

# pr-ready

Generate a PR-readiness report from the **currently staged** changes (`git diff --cached`). This skill is strictly read-only: it inspects and reports, and never changes repository state.

## Hard constraints

- **NEVER** run `git commit`, `git push`, `git stash`, `git reset`, `git checkout`, `git add`, `git rm`, or any command that modifies the working tree, index, or refs.
- **NEVER** create, edit, or delete files (the `Write` and `Edit` tools are intentionally not available).
- Only read state: `git diff`, `git status`, `git log`, `git show`, plus `Read` and `Grep`. If a step would change anything, stop and report instead.

## Steps

1. **Read the staged changes.** Run:
   ```bash
   git diff --cached
   ```
   If the output is empty, report that there are no staged changes and stop (suggest the user stage changes with `git add`, but do not run it).

2. **Gather light context** (read-only, optional but helpful):
   ```bash
   git diff --cached --stat
   git status
   git log --oneline -5
   ```
   Use these to understand which files changed and how the change fits recent history.

3. **Scan for risks.** Inspect the staged diff for:
   - **Secrets / credentials** — API keys, tokens, passwords, private keys, `.env` values, connection strings. Use `Grep` or scan the diff for patterns like `AKIA`, `secret`, `password`, `token`, `BEGIN PRIVATE KEY`, high-entropy strings.
   - **Debug / leftover statements** — `console.log`, `print(`, `debugger`, `TODO`, `FIXME`, `XXX`, commented-out code blocks.
   - **Mixed unrelated changes** — changes spanning unrelated areas/features that should be split into separate PRs.
   - **Missing context** — new functions/endpoints without tests, config changes without docs, breaking changes without notes.

4. **Produce the report** in the format below.

## Report format

```
# PR-Readiness Report

## Summary of changes
<Concise bullet list of what changed and why, grouped by area/file.>

## Risks worth a second look
<For each risk found, name it, cite the file/line, and say why it matters.
 If none, state "No blocking risks found" and list anything minor.>

## Drafted PR

### Title
<A clear, conventional PR title, e.g. "feat: ..." / "fix: ..." derived from the diff.>

### Description
<Markdown PR body: what & why, notable changes, testing notes, and any
 follow-ups or reviewer call-outs. Base it entirely on the staged diff.>
```

Keep the report grounded strictly in what appears in the staged diff — do not invent changes that aren't present.
