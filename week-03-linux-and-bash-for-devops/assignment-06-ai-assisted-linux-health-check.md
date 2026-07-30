<<<<<<< HEAD
# Assignment 6 — Build an AI-Assisted Linux Health Check (AI-Assisted Linux Incident Triage)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash triage script that checks the health of your Ubuntu server and Nginx application, connect it to Claude Code as a reusable `/linux-triage` skill, simulate a controlled Nginx incident, use the skill to gather and analyze evidence, recover the service manually, and verify recovery. The workflow follows the Agentic Loop: Gather → Analyze → Human Act → Verify.

---

# Task 1 — Confirm the Healthy Baseline and Create the Workspace

## Goal

Confirm that Nginx and the React application are healthy before building the automation.

### Evidence

#### Screenshot 1 — Output of `systemctl is-active nginx`, `ss -ltn | grep ':80'`, and `curl -I http://localhost`

![alt text](<screenshots/Screenshot (160).png>)

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort` showing the workspace folder structure

![alt text](<screenshots/Screenshot (161).png>)

---

### Notes

Answer the following in your own words:

**1. What proves that Nginx is running?**

The output of systemctl is-active nginx returning active confirms the Nginx service is currently running as a system process.

---

**2. What proves that the server is listening for HTTP traffic?**

The ss -ltn | grep ':80' output shows two LISTEN entries bound to port 80 (one for IPv4 0.0.0.0:80, one for IPv6 [::]:80), confirming the server is actively listening for incoming connections on the HTTP port.

---

**3. Why must you capture a healthy baseline before simulating an incident?**

A healthy baseline gives you a known-good reference point to compare against later. Without it, you couldn't reliably tell whether a failed check during the simulated incident is a new problem caused by the incident, or something that was already broken beforehand.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Tell Claude exactly what this project does and what it is not allowed to do.

### Evidence

#### Screenshot 3 — CLAUDE.md open in VS Code showing all four sections (Project Overview, Incident Workflow, Safety Rules, Output Rules)

![alt text](<screenshots/Screenshot (162).png>)

---

### Notes

Answer the following in your own words:

**1. Why should Claude receive project-specific operational rules?**

Without explicit rules, Claude has no way of knowing what's safe or appropriate for this specific environment. Project-specific rules constrain its behavior to exactly what's needed for this task  read-only diagnostics preventing it from taking actions that could be risky or unintended in a production-like system.

---

**2. Why is the human required to execute the recovery command?**

Automated recovery actions can have unintended consequences — restarting the wrong service, masking a deeper issue, or causing further instability. Requiring a human to review Claude's suggestion and manually execute it ensures there's always a deliberate, accountable decision-maker in the loop before any change is made to the live system.

---

**3. Which rule prevents Claude from making an unsupported diagnosis?**

The Safety Rule stating "Claude must base every conclusion strictly on the evidence provided by the triage script output — no assumptions or unsupported diagnoses" directly prevents this, reinforced by the Output Rule that Claude must not fabricate evidence that wasn't present in the script's output.

---

# Task 3 — Use Agentic AI to Plan Before Writing the Script

## Goal

Use Claude Code to inspect the environment and produce a read-only plan before creating any Bash code.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan and read-only inspection results

![alt text](<screenshots/Screenshot (163).png>)

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

Claude Code inspecting the environment — checking that tools like systemctl, ss, curl, df, and free are available and functional — represents the Gather phase. It's collecting information about the environment before any analysis or action takes place.

---

**2. Did Claude follow the instruction not to create files? How did you verify this?**

Yes — Claude only ran read-only inspection commands and presented the plan as text output, without creating any script or file. I verified this by running ls in the project directory afterward and confirming no new files had appeared

---

**3. Why is planning before coding useful in DevOps automation?**

Planning first ensures the script's logic and scope are agreed upon before any code is written, reducing the risk of building something that misses requirements or does more than intended. It also creates a clear checkpoint where a human can review and approve the approach before Claude generates code that will actually run in the environment.

---

# Task 4 — Build the Linux Triage Bash Script

## Goal

Create one Bash script that gathers consistent Linux and Nginx health evidence.

### Evidence

#### Screenshot 5 — Top section of `linux-triage.sh` showing variables, thresholds, and the checks array

![alt text](<screenshots/Screenshot (164).png>)

---

#### Screenshot 6 — Middle section showing check functions and conditionals

![alt text](<screenshots/Screenshot (165).png>)

---

#### Screenshot 7 — Bottom section showing the loop, summary function, and exit behavior

![alt text](<screenshots/Screenshot (166).png>)

---

#### Screenshot 8 — Output of `bash -n scripts/linux-triage.sh` (no syntax errors) and `ls -l scripts/linux-triage.sh` showing executable permission

![alt text](<screenshots/Screenshot (167).png>)

---

### Notes

Answer the following in your own words:

**1. What is stored in the checks array?**

The checks array stores the names/labels of the 5 health checks (Nginx status, port 80, HTTP response, disk usage, memory usage) that the script needs to run, allowing the script to reference and loop through them systematically.

---

**2. How does the `for` loop use that array?**

The for loop iterates through each item in the checks array one at a time, calling the corresponding check function for each entry and processing its result — allowing all 5 checks to run in sequence without repeating the same code 5 separate times.

---

**3. Why are the health checks separated into functions?**

Separating each check into its own function (e.g., check_nginx_status, check_port_80) keeps the script organized and makes each check self-contained and easy to test, debug, or modify individually without affecting the others.

---

**4. What is the purpose of `$(...)` in this script?**

$(...) is command substitution — it runs a command and captures its output as a value that can be stored in a variable. This is how the script captures things like the Nginx status output or disk usage percentage so it can be evaluated against thresholds.
---

**5. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

Different exit codes let other tools or scripts calling this one programmatically distinguish between "everything is fine" (0), "something needs attention but isn't critical" (a WARN-specific code), and "something is actually broken" (1 or another FAIL-specific code) — which is essential for automation, since exit codes are how scripts signal success/failure to whatever calls them (like a monitoring system or CI/CD pipeline).

---

# Task 5 — Run and Understand the Healthy-State Report

## Goal

Run the Bash script against the healthy server and verify that it creates a report.

### Evidence

#### Screenshot 9 — Output of `./scripts/linux-triage.sh` showing your Full Name and all five check results

![alt text](<screenshots/Screenshot (168).png>)

---

#### Screenshot 10 — Output showing the captured exit code and final summary

![alt text](<screenshots/Screenshot (169).png>)

---

### Notes

Answer the following in your own words:

**1. What is the overall status of your healthy baseline?**

All 5 checks returned HEALTHY: Nginx service status, port 80 listening, HTTP response from localhost, disk usage, and memory usage. The summary confirmed "5 HEALTHY, 0 WARN, 0 FAIL.

---

**2. Which exact Linux evidence proves the application is serving traffic?**

The HTTP response check shows GET http://localhost/ => HTTP 200, confirming the server actually responded successfully to a real HTTP request, not just that the process was running.

---

**3. Did your script return exit code 0 or 1? Explain why.**

The script returned exit code 0, because all 5 checks classified as HEALTHY with zero WARN or FAIL results — the script's logic exits with 0 only when every check passes.

---

**4. What is the difference between a warning and a failure in this script?**

A WARN indicates a check found something approaching a concerning threshold (like disk usage getting high) but not yet critical — the system is still functioning. A FAIL indicates the check found the system genuinely broken or unavailable (like Nginx not running, or an HTTP request failing entirely) — something requiring immediate attention.
cl
---

# Task 6 — Create and Run the /linux-triage Skill

## Goal

Turn the Bash script into a reusable, manually invoked Agentic AI workflow.

### Evidence

#### Screenshot 11 — `SKILL.md` showing the frontmatter, allowed tool restrictions, and safety rules

![alt text](<screenshots/Screenshot (170).png>)

---

#### Screenshot 12 — `/linux-triage` output for the healthy server

![alt text](<screenshots/Screenshot (171).png>)

---

### Notes

Answer the following in your own words:

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

Bash lets it run the triage script, Read lets it view file contents, and Grep lets it search through output or logs — all read-only or execution-only actions needed to gather and inspect evidence. Write is deliberately excluded so the skill can never create, modify, or delete files, keeping it strictly diagnostic and preventing it from making unintended changes to the system.

---

**2. Why is `disable-model-invocation: true` useful for this skill?**

This setting prevents Claude from automatically triggering the skill on its own initiative during a conversation. It ensures the skill only runs when I explicitly invoke it with /linux-triage, keeping a human in control of exactly when diagnostics are gathered rather than Claude deciding to run it unprompted.

---

**3. What part is performed by Bash, and what part is performed by Claude?**

Bash performs the actual evidence-gathering — running linux-triage.sh, which executes the real system commands (systemctl, ss, curl, df, free) and produces the raw report. Claude's role is limited to reading that output and summarizing it in plain language — it doesn't independently determine system state, it only interprets the evidence Bash already collected.

---

**4. Why is this better than asking Claude "Is my server healthy?" without giving it evidence?**

Without evidence, Claude would have no actual way to know the server's real state — any answer would be a guess or hallucination. By running the script first and grounding Claude's response strictly in that concrete output, the answer is based on real, verifiable system data rather than assumption

---

# Task 7 — Simulate an Nginx Incident and Let the Skill Diagnose It

## Goal

Create a controlled service failure, gather evidence through Bash, and let Claude analyze the evidence without taking recovery action.

### Evidence

#### Screenshot 13 — Output showing Nginx is inactive and the HTTP request fails

![alt text](<screenshots/Screenshot (172).png>)

---

#### Screenshot 14 — `/linux-triage` output showing failed evidence, most likely cause, and a suggested recovery command

![alt text](<screenshots/Screenshot (173).png>)

---

#### Screenshot 15 — `incident-failure-report.txt` showing the failed checks and your Full Name

![alt text](<screenshots/Screenshot (175).png>)

---

### Notes

Answer the following in your own words:

**1. Which three checks failed?**

Nginx service status, port 80 listening, and HTTP response from localhost all failed, since stopping Nginx meant it was no longer running, no longer listening on port 80, and no longer able to respond to HTTP requests. (Disk usage and memory usage checks were unaffected and remained HEALTHY.)

---

**2. What evidence supports the conclusion that Nginx is unavailable?**

The script's evidence showed systemctl is-active nginx returning something other than active (e.g., inactive or failed), no process listening on port 80 in the ss output, and the HTTP check failing to get a response (connection refused) instead of returning HTTP 200.

---

**3. Did Claude execute the recovery command? Why is that important?**

No — Claude only suggested the recovery command (sudo systemctl start nginx) without executing it, per the safety rules defined in CLAUDE.md and the skill's restricted toolset (no Write, and no execute-without-approval behavior for state-changing commands). This matters because it keeps a human accountable for approving any action that changes the live system, rather than letting an AI agent make that call unsupervised

---

**4. Which phase of the Agentic Loop is represented by the Bash report?**

The Gather phase — the Bash script collects raw, factual evidence about the system's current state without any interpretation or decision-making.

---

**5. Which phase is represented by Claude's explanation?**

The Analyze phase — Claude reviews the evidence the Bash script gathered and explains the most likely cause in plain language, without taking any action itself.

---

# Task 8 — Recover Manually, Verify Again, and Write the Incident Summary

## Goal

Recover the service as the human operator and prove that the system is healthy again.

### Evidence

#### Screenshot 16 — Output showing Nginx is active and `curl -I http://localhost` returns 200 OK

![alt text](<screenshots/Screenshot (176).png>)

---

#### Screenshot 17 — Second `/linux-triage` output showing successful recovery with no FAIL results

![alt text](<screenshots/Screenshot (176).png>)

---

#### Screenshot 18 — Output of `ls -lah reports` showing both `incident-failure-report.txt` and `recovery-report.txt`

![alt text](<screenshots/Screenshot (177).png>)

---

#### Screenshot 19 — `incident-summary.md` showing all required sections and your Full Name

![alt text](<screenshots/Screenshot (178).png>)

---

### Notes

Answer the following in your own words:

**1. What action did you execute manually?**

I ran sudo systemctl start nginx to restart the Nginx service after confirming it had stopped.

---

**2. What evidence proves that the service recovered?**

systemctl is-active nginx returned active, curl -I http://localhost returned HTTP/1.1 200 OK, and the linux-triage script's second run showed all 5 checks as HEALTHY with 0 FAIL, matching the original healthy baseline.

---

**3. Why is the second triage run necessary?**

A single successful command (like the service starting without error) doesn't guarantee the whole system is actually healthy again. Running the full triage script a second time confirms recovery across all 5 checks with the same objective evidence used to detect the original failure, rather than assuming recovery based on one action alone.

---

**4. What could go wrong if an AI agent automatically restarted every failed service?**

It could mask a deeper underlying problem (e.g., repeatedly restarting a service that's crashing due to a configuration error, without ever fixing the root cause), cause unintended side effects on other dependent services, or take an action in a context the AI doesn't fully understand — like restarting something during a maintenance window or while a human is actively debugging it.

---

**5. In one sentence, explain the difference between using AI as a chatbot and using AI in this agentic workflow.**

A chatbot just answers questions based on what it's told or already knows, while this agentic workflow has Claude gather real evidence from the live system, reason about that evidence, and operate within explicit safety boundaries that keep a human in control of any action that changes the system.

Once you've confirmed the cat incident-summary.md output, we'll wrap up with the LinkedIn post and GitHub repo link to finish this whole assignment.

---

# Incident Summary

Fill in all seven sections below in your own words.

**Full Name:** Andrew Ogunlana

**Date:** 22/07/2026

---

**1. Reported Symptom**

Add your answer here.

---

**2. Evidence Collected**

Add your answer here.

---

**3. Most Likely Cause**

Add your answer here.

---

**4. Human-Approved Recovery Action**

Add your answer here.

---

**5. Verification**

Add your answer here.

---

**6. Safety Decision**

Add your answer here.

---

**7. Agentic Loop Mapping**

Add your answer here.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/andrew-ogunlana-70654ba7_devops-ai-claudecode-share-7485916362238955520-NXnW/?utm_source=share&utm_medium=member_desktop&rcm=ACoAABau_jYBg6kU-k2bFgLhNF2byWrnftwaanA

---

#### Screenshot — Published LinkedIn post

![alt text](<screenshots/Screenshot (179).png>)

---

# GitHub Repository URL

Paste the URL of your GitHub folder or repository containing the assignment files here:

https://github.com/DMIC3ANDREW/linux-triage-project.git

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots and the Bash report
- All written answers must be in your own words
- Do not expose sensitive information (keys, passwords, AWS account IDs, tokens)
- GitHub URL must be included in this document

---

# Completion Checklist


- [✅ ] Task 1: Healthy baseline confirmed, workspace created (Screenshots 1–2, Notes answered)
- ✅[ ] Task 2: CLAUDE.md created with all four sections (Screenshot 3, Notes answered)
- [ ✅] Task 3: Five-check plan produced by Claude using read-only tools (Screenshot 4, Notes answered)
- [✅ ] Task 4: `linux-triage.sh` created, syntax validated, executable permission set (Screenshots 5–8, Notes answered)
- [✅ ] Task 5: Healthy-state report generated with no FAIL result (Screenshots 9–10, Notes answered)
- [✅ ] Task 6: `/linux-triage` skill created and run successfully on healthy server (Screenshots 11–12, Notes answered)
- [✅ ] Task 7: Nginx incident simulated, failed evidence captured, Claude did not execute recovery (Screenshots 13–15, Notes answered)
- [✅ ] Task 8: Nginx recovered manually, recovery verified, reports saved, incident summary complete (Screenshots 16–19, Notes answered)
- [✅ ] Incident summary contains all seven required sections
- [✅ ] LinkedIn post published and URL submitted
- [✅ ] Full Name visible in all required screenshots and the Bash report
- [✅ ] Skill does not have Write permission
- [✅ ] Skill did not execute any recovery commands
- [✅ ] No sensitive data exposed

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

=======
# Assignment 6 — Build an AI-Assisted Linux Health Check (AI-Assisted Linux Incident Triage)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash triage script that checks the health of your Ubuntu server and Nginx application, connect it to Claude Code as a reusable `/linux-triage` skill, simulate a controlled Nginx incident, use the skill to gather and analyze evidence, recover the service manually, and verify recovery. The workflow follows the Agentic Loop: Gather → Analyze → Human Act → Verify.

---

# Task 1 — Confirm the Healthy Baseline and Create the Workspace

## Goal

Confirm that Nginx and the React application are healthy before building the automation.

### Evidence

#### Screenshot 1 — Output of `systemctl is-active nginx`, `ss -ltn | grep ':80'`, and `curl -I http://localhost`

Add your screenshot here.

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort` showing the workspace folder structure

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What proves that Nginx is running?**

Add your answer here.

---

**2. What proves that the server is listening for HTTP traffic?**

Add your answer here.

---

**3. Why must you capture a healthy baseline before simulating an incident?**

Add your answer here.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Tell Claude exactly what this project does and what it is not allowed to do.

### Evidence

#### Screenshot 3 — CLAUDE.md open in VS Code showing all four sections (Project Overview, Incident Workflow, Safety Rules, Output Rules)

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Why should Claude receive project-specific operational rules?**

Add your answer here.

---

**2. Why is the human required to execute the recovery command?**

Add your answer here.

---

**3. Which rule prevents Claude from making an unsupported diagnosis?**

Add your answer here.

---

# Task 3 — Use Agentic AI to Plan Before Writing the Script

## Goal

Use Claude Code to inspect the environment and produce a read-only plan before creating any Bash code.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan and read-only inspection results

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

Add your answer here.

---

**2. Did Claude follow the instruction not to create files? How did you verify this?**

Add your answer here.

---

**3. Why is planning before coding useful in DevOps automation?**

Add your answer here.

---

# Task 4 — Build the Linux Triage Bash Script

## Goal

Create one Bash script that gathers consistent Linux and Nginx health evidence.

### Evidence

#### Screenshot 5 — Top section of `linux-triage.sh` showing variables, thresholds, and the checks array

Add your screenshot here.

---

#### Screenshot 6 — Middle section showing check functions and conditionals

Add your screenshot here.

---

#### Screenshot 7 — Bottom section showing the loop, summary function, and exit behavior

Add your screenshot here.

---

#### Screenshot 8 — Output of `bash -n scripts/linux-triage.sh` (no syntax errors) and `ls -l scripts/linux-triage.sh` showing executable permission

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is stored in the checks array?**

Add your answer here.

---

**2. How does the `for` loop use that array?**

Add your answer here.

---

**3. Why are the health checks separated into functions?**

Add your answer here.

---

**4. What is the purpose of `$(...)` in this script?**

Add your answer here.

---

**5. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

Add your answer here.

---

# Task 5 — Run and Understand the Healthy-State Report

## Goal

Run the Bash script against the healthy server and verify that it creates a report.

### Evidence

#### Screenshot 9 — Output of `./scripts/linux-triage.sh` showing your Full Name and all five check results

Add your screenshot here.

---

#### Screenshot 10 — Output showing the captured exit code and final summary

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is the overall status of your healthy baseline?**

Add your answer here.

---

**2. Which exact Linux evidence proves the application is serving traffic?**

Add your answer here.

---

**3. Did your script return exit code 0 or 1? Explain why.**

Add your answer here.

---

**4. What is the difference between a warning and a failure in this script?**

Add your answer here.

---

# Task 6 — Create and Run the /linux-triage Skill

## Goal

Turn the Bash script into a reusable, manually invoked Agentic AI workflow.

### Evidence

#### Screenshot 11 — `SKILL.md` showing the frontmatter, allowed tool restrictions, and safety rules

Add your screenshot here.

---

#### Screenshot 12 — `/linux-triage` output for the healthy server

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

Add your answer here.

---

**2. Why is `disable-model-invocation: true` useful for this skill?**

Add your answer here.

---

**3. What part is performed by Bash, and what part is performed by Claude?**

Add your answer here.

---

**4. Why is this better than asking Claude "Is my server healthy?" without giving it evidence?**

Add your answer here.

---

# Task 7 — Simulate an Nginx Incident and Let the Skill Diagnose It

## Goal

Create a controlled service failure, gather evidence through Bash, and let Claude analyze the evidence without taking recovery action.

### Evidence

#### Screenshot 13 — Output showing Nginx is inactive and the HTTP request fails

Add your screenshot here.

---

#### Screenshot 14 — `/linux-triage` output showing failed evidence, most likely cause, and a suggested recovery command

Add your screenshot here.

---

#### Screenshot 15 — `incident-failure-report.txt` showing the failed checks and your Full Name

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. Which three checks failed?**

Add your answer here.

---

**2. What evidence supports the conclusion that Nginx is unavailable?**

Add your answer here.

---

**3. Did Claude execute the recovery command? Why is that important?**

Add your answer here.

---

**4. Which phase of the Agentic Loop is represented by the Bash report?**

Add your answer here.

---

**5. Which phase is represented by Claude's explanation?**

Add your answer here.

---

# Task 8 — Recover Manually, Verify Again, and Write the Incident Summary

## Goal

Recover the service as the human operator and prove that the system is healthy again.

### Evidence

#### Screenshot 16 — Output showing Nginx is active and `curl -I http://localhost` returns 200 OK

Add your screenshot here.

---

#### Screenshot 17 — Second `/linux-triage` output showing successful recovery with no FAIL results

Add your screenshot here.

---

#### Screenshot 18 — Output of `ls -lah reports` showing both `incident-failure-report.txt` and `recovery-report.txt`

Add your screenshot here.

---

#### Screenshot 19 — `incident-summary.md` showing all required sections and your Full Name

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What action did you execute manually?**

Add your answer here.

---

**2. What evidence proves that the service recovered?**

Add your answer here.

---

**3. Why is the second triage run necessary?**

Add your answer here.

---

**4. What could go wrong if an AI agent automatically restarted every failed service?**

Add your answer here.

---

**5. In one sentence, explain the difference between using AI as a chatbot and using AI in this agentic workflow.**

Add your answer here.

---

# Incident Summary

Fill in all seven sections below in your own words.

**Full Name:** Add your full name here

**Date:** DD/MM/YYYY

---

**1. Reported Symptom**

Add your answer here.

---

**2. Evidence Collected**

Add your answer here.

---

**3. Most Likely Cause**

Add your answer here.

---

**4. Human-Approved Recovery Action**

Add your answer here.

---

**5. Verification**

Add your answer here.

---

**6. Safety Decision**

Add your answer here.

---

**7. Agentic Loop Mapping**

Add your answer here.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

#### Screenshot — Published LinkedIn post

Add your screenshot here.

---

# GitHub Repository URL

Paste the URL of your GitHub folder or repository containing the assignment files here:

`Add your URL here`

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots and the Bash report
- All written answers must be in your own words
- Do not expose sensitive information (keys, passwords, AWS account IDs, tokens)
- GitHub URL must be included in this document

---

# Completion Checklist

- [ ] Task 1: Healthy baseline confirmed, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: CLAUDE.md created with all four sections (Screenshot 3, Notes answered)
- [ ] Task 3: Five-check plan produced by Claude using read-only tools (Screenshot 4, Notes answered)
- [ ] Task 4: `linux-triage.sh` created, syntax validated, executable permission set (Screenshots 5–8, Notes answered)
- [ ] Task 5: Healthy-state report generated with no FAIL result (Screenshots 9–10, Notes answered)
- [ ] Task 6: `/linux-triage` skill created and run successfully on healthy server (Screenshots 11–12, Notes answered)
- [ ] Task 7: Nginx incident simulated, failed evidence captured, Claude did not execute recovery (Screenshots 13–15, Notes answered)
- [ ] Task 8: Nginx recovered manually, recovery verified, reports saved, incident summary complete (Screenshots 16–19, Notes answered)
- [ ] Incident summary contains all seven required sections
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots and the Bash report
- [ ] Skill does not have Write permission
- [ ] Skill did not execute any recovery commands
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

>>>>>>> upstream/main
*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*