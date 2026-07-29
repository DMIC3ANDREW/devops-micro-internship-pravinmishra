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

When a disk reaches 100% capacity, the operating system can no longer write any new data  and this causes problems far beyond just running out of storage space:

---

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

![alt text](<screenshots/Screenshot (123).png>)

---

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

![alt text](<screenshots/Screenshot (124).png>)

---

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

![alt text](<screenshots/Screenshot (125).png>)

---

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

I confirm the correct version is deployed by checking the file timestamps in /var/www/html against my last deployment time, and by searching for a deployment marker string I added to the build (e.g., "Deployed by Andrew on <date>"). If that marker matches the commit/build I intended to ship, I know the right version is live — rather than relying on assumption or an old cached build.

---

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

![alt text](<screenshots/Screenshot (126).png>)

---

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

![alt text](<screenshots/Screenshot (127).png>)

---

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

![alt text](<screenshots/Screenshot (128).png>)

---

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

I intentionally introduced a syntax error i misspelled a directive listen to listenn in the Nginx config to simulate a real misconfiguration.

---

**2. How did you fix the issue?**

I ran sudo nginx -t to identify exactly which line was invalid, corrected the syntax, re-ran nginx -t to confirm it passed, then reloaded Nginx with sudo systemctl reload nginx so the fix took effect without dropping the service.

---

**3. How can you avoid this kind of issue in real production systems?**

Always run nginx -t before every reload  never reload blindly. In real production, config changes should also go through version control and be tested in a staging environment before touching production.

---

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

![alt text](<screenshots/Screenshot (131).png>)

---

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

![alt text](<screenshots/Screenshot (132).png>)

---

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

I removed the index.html file from /var/www/html, which is the entry point Nginx serves by default. Nginx itself remained fully functional — it simply had no file to return, resulting in a 403 Forbidden response since directory listing is disabled.



**2. How did you fix the issue and restore the application?**

I restored the missing index.html file back to /var/www/html and verified recovery by running curl -I again, which confirmed the site returned a 200 OK response.

**3. What steps would you take to prevent this kind of issue in real production systems?**

Deploy application files through a version-controlled, automated deployment process rather than manual file operations, so files can't be accidentally deleted or go missing. Automated uptime/health-check monitoring that alerts on non-200 responses would also catch this kind of issue immediately, before real users are affected.

---

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

SSH key-based authentication vs. sharing passwords: SSH keys use a public/private key pair instead of a shared secret — the private key never leaves your machine, so it can't be intercepted or brute-forced the way a password can. Passwords are also often reused across systems, which keys avoid entirely. This assignment reinforced this directly: I had to use a private .pem key file to authenticate to my EC2 instance, and permissions on that key file are strictly enforced (SSH refuses to use a key that's too open).

---

**2. Why should only required ports be open on a production server?**

Only required ports open: Every open port is a potential entry point for an attacker to probe or exploit. In this assignment, I only opened port 22 (SSH, restricted to my IP) and port 80 (HTTP, for public web traffic) — nothing else, minimizing the attack surface.

---

**3. Why is it important for Nginx to be enabled on boot?**

If the server restarts unexpectedly (crash, maintenance, reboot) and Nginx isn't set to start automatically, the site goes down until someone manually intervenes. Enabling it on boot makes the service self-healing after a restart.

---

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

Anyone who obtains a leaked private key or credential can impersonate you, access private systems, steal or destroy data, or run up costs on cloud resources — often without you even knowing until real damage is done. This is exactly why .pem files should never be committed to a public GitHub repo.

---

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Idle EC2 instances still incur billing charges and remain a live attack surface even when not actively used. Shutting them down when no longer needed reduces both unnecessary cost and unnecessary risk — this is also why I had to relaunch a fresh instance partway through this assignment, since the original one had been terminated.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

<https://www.linkedin.com/posts/andrew-ogunlana-70654ba7_devops-react-nginx-share-7483836843285884929-LEB9/?utm_source=share&utm_medium=member_desktop&rcm=ACoAABau_jYBg6kU-k2bFgLhNF2byWrnftwaanA>


---

#### Screenshot — Published LinkedIn post

https://www.linkedin.com/pulse/my-react-app-week-3-andrew-ogunlana-3aa7e

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [✅] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [✅] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [✅] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [✅] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [✅] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [✅] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [✅] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [✅] Task 8: Security & Reliability Notes answered
- [✅] LinkedIn post published and URL submitted
- [✅] Full Name visible in all required screenshots
- [✅] No sensitive data exposed

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