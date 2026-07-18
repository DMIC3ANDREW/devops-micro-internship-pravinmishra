# Assignment 3 — Production Maintenance Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will treat your already deployed React application (on Ubuntu VM with Nginx) as a live production system. You will perform structured operational checks covering network validation, service health, log analysis, resource monitoring, configuration verification, and incident simulation with recovery — mirroring real on-call DevOps responsibilities.

---

# Task 1 — Server Access & Networking Validation

## Goal

Verify that the deployed React application is reachable from the browser and confirm basic network connectivity of the Ubuntu VM.

### Evidence

#### Screenshot 1 — Browser showing the React app with your Full Name visible on the UI

![alt text](<screenshots/Screenshot (Task 1).png>)

---

#### Screenshot 2 — Output of `ip a`

![alt text](<screenshots/Screenshot (Task 2).png>)

---

#### Screenshot 3 — Output of `sudo ss -tulpen`

![alt text](<screenshots/Screenshot (Task 3).png>)

---

#### Screenshot 4 — Output of `sudo ufw status`
![alt text](<screenshots/Screenshot (Task 4).png>)

---

### Notes

Answer the following in your own words:

**1. What proves Nginx is listening on 0.0.0.0:80?**

The output of sudo ss -tulpen includes the following line:
tcp   LISTEN   0   511   0.0.0.0:80   0.0.0.0:*   users:(("nginx",pid=333,fd=5),("nginx",pid=330,fd=5),("nginx",pid=328,fd=5),("nginx",pid=327,fd=5),("nginx",pid=326,fd=5))
This line proves three things at once:

LISTEN — the socket is actively accepting incoming connections, not idle or closed.
0.0.0.0:80 — it's bound to port 80 (the standard HTTP port) on 0.0.0.0, meaning "all network interfaces." This is important because it means Nginx accepts connections from any IP that can reach the machine, not just from the machine itself (which would show as 127.0.0.1:80 instead).
users:(("nginx", pid=333...)) — the process name and PIDs confirm it's specifically the nginx process holding that port, with multiple worker processes (326, 327, 328, 330, 333) attached — nginx's normal multi-worker architecture.

Together, this confirms Nginx is up, actively listening, and reachable from outside the local machine on port 80.



---

**2. What proves SSH is active on port 22?**

Nothing does — SSH is not active on this system. Checking sudo ss -tulpen shows no line containing :22 anywhere in the output, only nginx on port 80 and the local DNS resolver on port 53.

---

**3. Did you find any unexpected open ports? Explain briefly.**

No unexpected ports were found. The ss -tulpen output showed only expected, explainable services:

Port 80 — Nginx, serving the deployed React application (expected — this is the whole point of the setup).
Port 53 (two entries, 127.0.0.53 and 127.0.0.54) — systemd-resolved, the system's internal DNS resolver (a normal background service on Ubuntu, not something I configured).
Port 323 (UDP) — chronyd, used for system time synchronization (also a standard background service).

---

# Task 2 — Service Health & Systemd Validation (Nginx)

## Goal

Verify that Nginx is properly installed, running, enabled at boot, and safely configured.

### Evidence

#### Screenshot 1 — Output of `systemctl status nginx --no-pager`

![alt text](<screenshots/Screenshot (4).png>)

---

#### Screenshot 2 — Output of `sudo nginx -t`

![alt text](<screenshots/Screenshot (new 1).png>)

---

#### Screenshot 3 — Output of `sudo ss -lptn '( sport = :80 )'`

![alt text](<screenshots/Screenshot (new 2).png>)

---

### Notes

Answer the following in your own words:

**1. What happens if Nginx fails to restart in production?**

If Nginx fails to restart — most commonly due to a broken or invalid configuration file — the service stops serving traffic entirely. Because systemctl (and nginx -t internally) validates configuration before applying it, a bad config means the new process won't start at all. If the restart command first stops the existing running process before attempting to start the new one, the result is a complete outage: the old (working) instance is gone, and the new one never comes up.

---

**2. What's your basic rollback plan?**

ere's the answer:

My basic rollback plan has three parts:

Backup before changing anything — before editing any Nginx config, I copy the current working version:

bashsudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

Test before applying — after making a change, I always run sudo nginx -t first. If it reports a syntax error, I don't restart the service at all — I fix the file or immediately restore the backup instead.
Restore if something breaks — if a bad config somehow does get applied, I roll back immediately with:

---

# Task 3 — Logs & Request Trace

## Goal

Verify real traffic flow and analyze logs to understand system behavior and errors.

### Evidence

#### Screenshot 1 — Output of `sudo tail -n 30 /var/log/nginx/access.log`

![alt text](<screenshots/Screenshot (new 3).png>)

---

#### Screenshot 2 — Output of `sudo tail -n 30 /var/log/nginx/error.log`

![alt text](<screenshots/Screenshot (new 3).png>)

---

#### Screenshot 3 — Output of `sudo journalctl -u nginx --no-pager -n 50`

![alt text](<screenshots/Screenshot (new 5).png>)

---

### Notes

Answer the following in your own words:

**1. Were there any errors in the logs?**

- If yes, mention 1–2 example error lines from the logs and explain what each one means in simple terms.
- If no, explain what it means if the error log is empty or shows no recent errors during your check.

o errors were found. When I checked sudo tail -n 30 /var/log/nginx/error.log, the command returned completely empty — no lines at all.

---

**2. If there were no errors, what does that indicate about the system?**

An error-free log, combined with all-200 responses in the access log, indicates the system is in a healthy, stable state end-to-end:

Nginx is correctly configured — no syntax or routing errors are causing failed requests.
All requested files exist and are accessible — the React build files (index.html, CSS, JS, favicon) are present in /var/www/html with correct permissions, since a missing file or permissions issue would generate a 404 or 403 and show up in the error log.
The deployment pipeline worked as intended — from build, to copy, to nginx configuration, every step completed successfully with nothing broken in between.

---

**3. Based on the access logs, were your curl requests visible in the log entries? What does that prove about traffic flow?**

yes This proves the full request-to-log pipeline is working correctly:

A request is sent to the server (via curl).
Nginx receives it, processes it, and returns a response.
Nginx accurately logs the request — including source IP, timestamp, method, path, status code, and client type — in real time.

---

# Task 4 — System Resource Health Check (Capacity Red Flags)

## Goal

Assess server capacity and detect potential performance or failure risks.

### Evidence

#### Screenshot 1 — Output of `uptime`

![alt text](<screenshots/Screenshot (119).png>)

---

#### Screenshot 2 — Output of `free -h`

![alt text](<screenshots/Screenshot (120).png>)

---

#### Screenshot 3 — Output of `df -h`

![alt text](<screenshots/Screenshot (121).png>)

---

#### Screenshot 4 — Output of `sudo du -sh /var/* | sort -h`

![alt text](<screenshots/Screenshot (122).png>)

---

### Notes

Answer the following in your own words:

**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

none of the three resources (CPU, memory, disk) are currently critical — all show significant headroom.

---

**2. What happens if disk becomes 100% full in a production server?**

When a disk reaches 100% capacity, the operating system can no longer write any new data — and this causes problems far beyond just running out of storage space:

---

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

Add your screenshot here.

---

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

Add your screenshot here.

---

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

Write your answer here.

---

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

Add your screenshot here.

---

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

Add your screenshot here.

---

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

Write your answer here.

---

**2. How did you fix the issue?**

Write your answer here.

---

**3. How can you avoid this kind of issue in real production systems?**

Write your answer here.

---

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

Add your screenshot here.

---

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

Write your answer here

---

**2. How did you fix the issue and restore the application?**

Write your answer here.

---

**3. What steps would you take to prevent this kind of issue in real production systems?**

Write your answer here.

---

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

Write your answer here.

---

**2. Why should only required ports be open on a production server?**

Write your answer here.

---

**3. Why is it important for Nginx to be enabled on boot?**

Write your answer here.

---

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

Write your answer here.

---

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Write your answer here.

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

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [ ] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [ ] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [ ] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [ ] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [ ] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [ ] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [ ] Task 8: Security & Reliability Notes answered
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots
- [ ] No sensitive data exposed

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