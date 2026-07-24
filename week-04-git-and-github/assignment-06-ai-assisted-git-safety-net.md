# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

![alt text](<screenshots/Screenshot (232).png>)

---

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

Working on a dedicated branch keeps experimental or in-progress changes isolated from the stable main branch. If something goes wrong or needs to be abandoned, main remains untouched and safe — this is the same isolation principle practiced in the CodeTrack branching assignment, just applied here to a real safety-tooling feature.

---

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of  `git status` showing the staged file on feature/ai-pr-ready

![alt text](<screenshots/Screenshot (233).png>)

---

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

Using a real secret anywhere in a public repository (even temporarily, even if later removed) is dangerous  Git history retains old commits, so a real leaked credential could be found and exploited by anyone browsing the repo's history, even after being deleted in a later commit. A well-known fake example key (like AWS's own documented AKIAIOSFODNN7EXAMPLE) lets us safely test the exact same detection pattern without any real security risk.

---

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script

![alt text](<screenshots/Screenshot (234).png>)

---

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

![alt text](<screenshots/Screenshot (235).png>)

---

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

Files inside .git/hooks/ are local-only and never get committed or shared — anyone who clones the repo wouldn't get that protection automatically. By keeping the script in a tracked folder like hooks/ and pointing core.hooksPath to it, the safety net becomes part of the actual codebase, so every contributor who clones the repo and sets core.hooksPath gets the same protection.

---

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

PreToolUse intercepts an AI agent's tool call before it executes, blocking risky agent actions before they run. This pre-commit hook intercepts a Git commit before it's created, blocking risky code changes before they enter history. Both operate on the same principle: catching a risky action before it happens rather than after, using fixed, predictable rules rather than judgment calls.

---

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

![alt text](<screenshots/Screenshot (236).png>)

---

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**


Line 25: grep -E "AKIA[0-9A-Z]{16}" "$FILE". This matched because AWS access keys always start with the literal prefix AKIA followed by exactly 16 uppercase letters or digits — my fake key AKIAIOSFODNN7EXAMPLE follows that exact format, so the regex pattern matched it directly.

---

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

No — if a secret were stored in a variable without a recognizable pattern (e.g., const x = "8f3k29dj..." with no keyword like PASSWORD/SECRET/API_KEY nearby, and not matching AWS's specific key format), this hook would miss it entirely. This shows that fixed rules are only as good as the patterns they're written to detect — they're fast and reliable for known patterns, but blind to anything that doesn't match their exact syntax, which is exactly why a second layer of judgment-based review (like the /pr-ready skill) is valuable alongside it.

---

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

![alt text](<screenshots/Screenshot (237).png>)

---

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

![alt text](<screenshots/Screenshot (238).png>)

---

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

Bash lets it run read-only Git commands like git diff --cached to inspect the staged changes, and Read lets it view file contents directly. Write is deliberately excluded so the skill can only observe and report — it has no way to create, edit, or alter any file, guaranteeing it stays a pure analysis tool rather than something capable of changing the codebase.

---

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

Both flagged the AWS key pattern and the hardcoded password — the same two things the fixed-rule hook was designed to catch. But /pr-ready caught additional issues the hook has no concept of: the password being printed to logs via console.log (a judgment call about consequence, not just pattern-matching), the leftover TODO comment, the fact that connectToDatabase() doesn't actually do anything functional, and the missing test coverage. This shows the hook is fast and reliable for known patterns, while the AI skill can reason about context, intent, and completeness in ways a fixed rule fundamentally can't.

---

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

![alt text](<screenshots/Screenshot (239).png>)

---

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

![alt text](<screenshots/Screenshot (240).png>)

---

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

I replaced the hardcoded AWS access key and database password with references to environment variables (process.env.AWS_ACCESS_KEY_ID and process.env.DB_PASSWORD), removed the console.log statement that printed the password to the console, and removed the leftover TODO comment — eliminating both patterns the hook was designed to detect.

---

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

**Important:** Open this Pull Request with base repository set to **your own fork** — not the shared upstream `pravinmishraaws/devops-micro-internship-pravinmishra` repository. This assignment's hook and skill files are your own practice work, not a change meant for the shared class repo.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison (paste it in the PR conversation or your notes below)

![alt text](<screenshots/Screenshot (241).png>)

---

#### PR Link

https://github.com/DMIC3ANDREW/devops-micro-internship-pravinmishra/pull/1

---

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

I removed the warning line the AI included ("⚠️ This diff is not ready to open as a PR...") since that warning applied to the earlier, unfixed version of the file — by the time I opened the PR, the secrets had already been removed, so that caveat was no longer accurate and would have been misleading to include.

---

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

If I'd copy-pasted the first draft (generated while the file still had secrets), I could have opened a PR with a description explicitly warning that the code wasn't safe to merge — while simultaneously trying to merge it. More broadly, blindly trusting an AI-generated description risks including inaccurate claims, missing important context only I would know, or including a warning/caveat that no longer applies to the current state of the code.

---

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

This assignment's hook and skill files are personal practice tooling for learning Git safety mechanisms — they aren't a change intended for the shared class repository that other students and the DMI mentors submit their own work into. Opening it against upstream would incorrectly submit personal practice work as a proposed change to the shared curriculum repo.

---

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

Both the pre-commit hook running its pattern checks and /pr-ready running git diff --cached represent Gather — they're both collecting raw evidence about the staged changes before any conclusion is drawn.

---

**2. Which step(s) represent Analyze?**

The pre-commit hook's pass/fail decision based on its fixed rules, and /pr-ready's risk report and PR draft, both represent Analyze — turning the gathered evidence into a conclusion or recommendation.

---

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

Actually running git commit, git push, and creating the Pull Request is the Human Act step. A human must perform these because they're the point where a change becomes real and visible to others — permanently entering Git history and potentially being reviewed or merged by other people. Keeping this step human-only ensures someone accountable has reviewed the AI's analysis and made the final call, rather than an AI agent unilaterally publishing changes.

---

**4. Which step is Verify?**

Re-running the pre-commit hook (via a successful git commit) and re-running /pr-ready after fixing the issues represents Verify — confirming the fix actually worked using the same evidence-gathering tools that originally caught the problem.

---

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

The fixed-rule hook is fast, deterministic, and can't be talked out of blocking a known-bad pattern, but it's blind to anything outside its exact rules (like a password being logged, or missing context). The AI skill can reason about nuance and intent that a fixed rule can't capture, but it isn't a hard guarantee — it can only suggest, and its judgment could be wrong or incomplete, so it can't be trusted as the sole safety gate the way a deterministic rule can

---

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

https://www.linkedin.com/posts/andrew-ogunlana-70654ba7_devops-git-ai-share-7486392758350282753-AeI1/?utm_source=share&utm_medium=member_desktop&rcm=ACoAABau_jYBg6kU-k2bFgLhNF2byWrnftwaanA

---

## Key Learnings

Add 3-5 bullet points on what you learned this week.

-
1. Fixed-rule checks (like the pre-commit hook) are fast and completely predictable, but only catch exactly what they're written to detect — anything outside that pattern slips through invisibly.
2. AI-based review can reason about context and consequence (like a password ending up in logs) that a regex-based rule has no way to understand.
3. Keeping "Write" access out of an AI skill's toolset is a simple but powerful safety boundary — it forces the AI to only ever suggest, never act, no matter how confident its analysis is.
4. Reading and editing an AI's drafted output before using it matters in practice, not just in theory — the first PR draft explicitly said "not ready to merge," and blindly using it would have looked careless.
5. The same Gather → Analyze → Human Act → Verify loop applies far beyond incident response — it's a general pattern for any workflow where AI assists but a human remains accountable for real-world actions.

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission — the fake key in Task 1 is intentional and must stay clearly fake
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

Paste your forked repository URL here:

`Add your URL here`

---

# Completion Checklist


- [ ✅ ] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [ ✅ ] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [ ✅ ] `core.hooksPath` configured to point at `hooks/`
- [ ✅ ] Pre-commit hook shown blocking the risky commit
- [ ✅ ] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [ ✅ ] `/pr-ready` run against the risky diff and shown flagging issues
- [ ✅] Risky file fixed; `git commit` succeeds cleanly
- [ ✅ ] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [ ✅] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [ ✅ ] Agentic Loop mapping (Task 7) completed in your own words
- [ ✅ ] LinkedIn post published and URL submitted
- [ ✅ ] All required screenshots added
- [ ✅] GitHub repository URL provided

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
