
# Week 00 - Internet and Networking

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

# 🧑‍💻 Task 1: Using ChatGPT as Your Learning Assistant

## Scenario

You're new to DevOps and will frequently encounter technical questions. ChatGPT can be your learning companion.

## Your Task

Write a clear ChatGPT prompt to help you understand:

> "What is a protocol in networking? Explain with a simple real-life example."

Take a screenshot of your interaction showing:

* Your detailed prompt (with clear expectations)
* ChatGPT's simplified response with an example

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![Task 1](<screenshots/Screenshot (244).png>)


Replace `task-1-chatgpt.png` with your actual screenshot file name.

---

## What I Learned (2–3 lines)

I learned that protocols are simply rules that help computers communicate correctly. I also learned that websites and devices rely on these rules every time information is sent across the Internet.

---

# 🌐 Task 2: Internet and Networking

## Scenario

Your friend is launching an online bookstore named **EpicReads**.

He asked you to explain how users globally can access his website hosted in Finland.

## Your Task

Write a short explanation (**100–150 words**) that includes:

* Packet Switching
* IP Address
* TCP/IP
* HTTP/HTTPS

💡 **Tip:** You may use ChatGPT (as demonstrated in Task 1) to refine your explanation.

## Answer

EpicReads is an online bookstore hosted in Finland, but people worldwide can still access it because the Internet follows common communication rules. When someone visits EpicReads, their request is broken into smaller pieces called packets using Packet Switching. These packets travel across different networks and are reassembled when they arrive. Every device connected to the Internet has an IP Address, which works like a house number that helps information reach the correct destination. TCP/IP makes sure the packets are delivered properly and in the correct order. Finally, HTTP or HTTPS allows web browsers and websites to communicate. HTTPS also protects users by encrypting their information, making online activities such as signing in or making payments much safer.

---

# 🏗️ Task 3: Application Architecture & Stack

## Scenario

EpicReads bookstore has two application versions:

### Two-Tier Application

* Frontend
* Database

### Three-Tier Application

* Frontend
* Backend
* Database

## Your Task

* Draw simple diagrams (hand-drawn or tool-based such as draw.io)
* Label each layer clearly
* List at least two common technologies or tools used for each layer
* Submit a screenshot or photo clearly showing your own drawing

## Diagram Screenshot / Photo

Save your diagram image in the `screenshots` folder and update the file name below.

![Task 3](<screenshots/screenshot three tier.PNG>)
![Task 3](<screenshots/screenshot two tier.PNG>)

Replace `task-3-diagram.png` with your actual diagram file name.

---

## Technologies Used

### Frontend

1. HTML/CSS
2. React

### Backend

1. Node.js
2. Python

### Database

1. MySQL
2. PostgreSQL

---

# 🌍 Task 4: Domain Name & DNS (Basic Concepts)

## Scenario

Your friend's bookstore **EpicReads** is currently accessible through:

```text
52.172.142.222:3000
```

He purchased the domain:

```text
epicreads.com
```

## Your Task

In **50–100 words**, explain in your own words:

1. What is DNS (Domain Name System)?
2. Which DNS record type should be used to connect the domain to the given IP, and why?

## Answer

DNS (Domain Name System) works like the contact list on your phone. You remember someone's name instead of their phone number because your phone finds the correct number for you. Similarly, DNS converts a domain name such as epicreads.com into its IP address so computers can find the correct website. The DNS record used to connect a domain directly to an IP address is called an A Record. It is used because it maps a domain name to an IPv4 address, allowing users to visit the website without remembering numbers such as 52.172.142.222.

---

# 💻 Task 5: Visual Studio Code Setup (Hands-on)

## Your Task

Install Visual Studio Code (if not already installed).

Take a screenshot of your VS Code environment showing:

* Terminal open inside VS Code
* Running a basic command:

### Windows

```powershell
dir
```

### Linux / macOS

```bash
pwd
ls
```

* Your selected VS Code theme clearly visible

⚠️ **Important:** The screenshot must show your username or another identifiable detail to confirm it is your environment.

## Screenshot

Save your screenshot in the `screenshots` folder and update the file name below.

![Task 5](<screenshots/Screenshot (powershell).png>)
![Task 5](<screenshots/Screenshot (vs code).png>)


Replace `task-5-vscode.png` with your actual screenshot file name.

---

# 🔗 Task 6: Publish Your Assignment as a LinkedIn Post

## Objective

Publishing on LinkedIn helps you:

* Build your professional online presence
* Reinforce your learning
* Document your DevOps journey publicly

## Your Task

Summarize your answers from Tasks 1–5 into a LinkedIn post.

Clearly structure your post into the following sections:

* ChatGPT
* Internet & Networking
* App Architecture
* DNS
* VS Code Setup

Add the following credit note at the end of your post:

> **P.S. This post is a part of DevOps Micro Internship with Agentic AI Cohort-3 by Pravin Mishra. You can start your DevOps journey by joining this Discord community: https://discord.pravinmishra.com/**

---

## LinkedIn Post URL

Paste your LinkedIn post URL here:

```text
https://www.linkedin.com/posts/andrew-ogunlana-70654ba7_today-i-completed-week-00-of-my-devops-learning-share-7488239298404655104-hTtw/?utm_source=share&utm_medium=member_desktop&rcm=ACoAABau_jYBg6kU-k2bFgLhNF2byWrnftwaanA
```

---

## LinkedIn Post Backup Copy

Paste the full text of your LinkedIn post here:

Today, I completed Week 00 of my DevOps learning journey and gained a better understanding of how the Internet works.

### ChatGPT

I learned how to use ChatGPT as a learning assistant by asking detailed questions and receiving beginner-friendly explanations of networking concepts.

### Internet & Networking

I learned about:

* Networking Protocols
* Packet Switching
* IP Addresses
* TCP/IP
* HTTP and HTTPS

One interesting lesson was discovering that an IP address is like a house number, while DNS works like Google Maps by helping users find websites easily.

### Application Architecture

I learned the difference between Two-Tier and Three-Tier applications.

* Frontend – what users interact with.
* Backend – processes requests and performs business logic.
* Database – stores information safely.

### DNS

I discovered that DNS translates domain names into IP addresses and that an A Record connects a domain name directly to an IPv4 address.

### VS Code Setup

I successfully explored Visual Studio Code's integrated terminal and practiced basic commands to navigate my development environment.

This week taught me that complex technical concepts become easier when explained with real-life examples.

**P.S. This post is a part of DevOps Micro Internship with Agentic AI Cohort-3 by Pravin Mishra. You can start your DevOps journey by joining this Discord community: https://discord.pravinmishra.com/**


---

# Reflection – Week 0

### What did you find easy?

I found understanding protocols and application architectures easy because relating them to real-life examples made the concepts simpler.

---

### What was difficult?

Understanding how TCP/IP, Packet Switching, and DNS work together was slightly difficult at first because several technologies are involved at the same time.

---

### What will you improve next week?

Next week, I will spend more time practicing Linux commands, networking concepts, and understanding how applications communicate over the Internet.

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.


## 📌 Resources

- 🌐 **DMI Official Website:** https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 **University:** https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 **Discord Community:** https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 **Blog:** https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ **YouTube Playlist (DMI Cohort 3):** https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 **Pravin Mishra (LinkedIn):** https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 **CloudAdvisory (LinkedIn):** https://www.linkedin.com/company/thecloudadvisory/

---

