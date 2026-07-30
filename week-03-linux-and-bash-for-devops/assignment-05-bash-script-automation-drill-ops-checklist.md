<<<<<<< HEAD
# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on your system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

![alt text](<screenshots/Screenshot (144).png>)

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

![alt text](<screenshots/Screenshot (145).png>)

---

### Notes

Answer the following in your own words:

**1. What is Bash?**

Bash (Bourne Again SHell) is a command-line interpreter and scripting language used on Linux and Unix systems. It lets you run commands interactively and also write scripts to automate repetitive tasks.

---

**2. What is the difference between shell and Bash?**

Shell is a general term for any program that provides a command-line interface between the user and the operating system (examples include sh, zsh, and Bash). Bash is one specific, widely-used implementation of a shell — it's a type of shell, not a separate category of thing.

---

**3. Why is it important to confirm the Bash version before writing scripts?**

Different Bash versions support different features and syntax (for example, associative arrays require Bash 4+). Confirming the version upfront avoids writing a script that fails or behaves unexpectedly when run on a system with an older or different version of Bash.

---

# Task 2 — Your First Bash Script

## Goal

Create your first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

![alt text](<screenshots/Screenshot (146).png>)

---

#### Screenshot 2 — Output of `./first-script.sh`

![alt text](<screenshots/Screenshot (147).png>)

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

![alt text](<screenshots/Screenshot (148).png>)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `#!/bin/bash`?**

This is called a "shebang" line. It tells the operating system which interpreter should be used to run the script

---

**2. Why do we use `chmod +x` before running a script?**

By default, newly created files aren't executable — Linux blocks them from being run as programs for security reasons. chmod +x adds the executable permission, telling the system this file is allowed to be run directly rather than just read or edited.

---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

./script.sh runs the file directly as a program, which requires the executable permission to be set and relies on the shebang line to determine the interpreter. bash script.sh explicitly tells Bash to interpret and run the file's contents, which works even without executable permission, since you're not "running the file" — you're passing it as input to Bash.

---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

![alt text](<screenshots/Screenshot (149).png>)

---

#### Screenshot 2 — Output of `./user-info.sh`

![alt text](<screenshots/Screenshot (149).png>)

---

### Notes

Answer the following in your own words:

**1. What is a variable in Bash?**

A variable is a named container that stores a piece of data — like text or a number — so it can be reused throughout a script instead of retyping the value each time.

---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Bash treats name = "value" differently from name="value". With spaces, Bash interprets name as a command and tries to pass = and "value" as arguments to it, which causes an error. No spaces is required syntax for correct variable assignment.

---

**3. How do you access the value stored inside a Bash variable?**

By prefixing the variable name with a dollar sign, e.g. $name or ${name}. This tells Bash to substitute the variable's stored value in that spot.


---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

![alt text](<screenshots/Screenshot (150).png>)

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

![alt text](<screenshots/Screenshot (150).png>)

---

### Notes

Answer the following in your own words:

**1. What is an array in Bash?**

An array is a variable that can hold multiple values (a list) instead of just one, indexed by position starting at 0. It lets you group related data together under a single name

---

**2. Why are arrays useful in scripts?**

hey let you store a collection of related items like a list of tools, filenames, or servers and process them together with loops, instead of writing a separate variable and command for each individual item.

---

**3. What does `"${tools[@]}"` mean?**

This expands to all the elements in the tools array, treating each one as a separate, individual item. The quotes ensure that items containing spaces (like "AWS CLI") are treated as a single element rather than being split into multiple words.

---

**4. What is the purpose of the `for` loop in this script?**

It iterates through each item in the tools array one at a time, running the echo command once per tool so every item in the checklist gets printed automatically, without writing a separate echo line for each one.

---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

![alt text](<screenshots/Screenshot (151).png>)

---

#### Screenshot 2 — Output of `./counter.sh`

![alt text](<screenshots/Screenshot (151).png>)

---

### Notes

Answer the following in your own words:

**1. What is a loop?**

A loop is a control structure that repeats a block of code multiple times, either a fixed number of times or until a certain condition is met, instead of writing the same instruction repeatedly.
---

**2. Why do we use loops in Bash scripting?**

Loops let us automate repetitive tasks efficiently — like processing a list of files, retrying a failed command, or printing a sequence — without manually duplicating code for every repetition

---

**3. How many times did the loop run in your script?**

The loop ran 5 times, once for each number in the sequence 1 2 3 4 5.

---

**4. What would you change if you wanted the loop to run 10 times?**

I'd change the sequence to 1 2 3 4 5 6 7 8 9 10, or more efficiently use a range like {1..10}, so the line would read: for i in {1..10}.

---

# Task 6 — Files & Conditionals: File Validation Script

## 
Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

![alt text](<screenshots/Screenshot (152).png>)
---

#### Screenshot 2 — Content of `file-check.sh`

![alt text](<screenshots/Screenshot (153).png>)

---

#### Screenshot 3 — Output of `./file-check.sh`

![alt text](<screenshots/Screenshot (153).png>)

---

### Notes

Answer the following in your own words:

**1. What does `-d` check in Bash?**

-d checks whether a given path exists and is a directory. It returns true only if the path points to a folder, not a file.

---

**2. What does `-f` check in Bash?**

-f checks whether a given path exists and is a regular file (not a directory, symlink, or other special type).

---

**3. Why should file and directory paths be stored in variables?**

It makes scripts easier to read and maintain — if the path ever changes, you update it in one place (the variable) rather than every line that references it. It also reduces the risk of typos when the same path is used multiple times.

---

**4. What happens if the file does not exist?**

The -f test returns false, so the script moves to the else block and prints "File not found" instead of "File exists" — allowing the script to handle the missing-file case gracefully instead of crashing or behaving unpredictably.

---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

![alt text](<screenshots/Screenshot (154).png>)

---

#### Screenshot 2 — Output showing `Result: Pass`

![alt text](<screenshots/Screenshot (154).png>)

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`

![alt text](<screenshots/Screenshot (155).png>)

---

#### Screenshot 4 — Output showing `Result: Retry`

![alt text](<screenshots/Screenshot (155).png>)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of if-else in Bash?**

if-else lets a script make decisions and branch its behavior based on whether a condition is true or false — running one block of code if a condition holds, and a different block if it doesn't.

---

**2. What does `-ge` mean?**

-ge stands for "greater than or equal to." It's used to compare two numbers, returning true if the first value is greater than or equal to the second.

---

**3. Why should conditions be tested with different values?**

Testing with values on both sides of the threshold (e.g., 85 and 55 around a 60 cutoff) confirms the logic actually branches correctly in both directions, rather than just happening to work for one lucky input. It catches bugs that a single test case would miss.

---

**4. How can conditionals help in automation scripts?**

Conditionals let scripts respond intelligently to different situations automatically — like checking if a deployment succeeded before proceeding, retrying a failed step, or skipping an action if a file already exists — without needing a human to manually decide each time.

---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-aut

![alt text](<screenshots/Screenshot (156).png>)
---

#### Screenshot 2 — Output of `./final-automation.sh`

![alt text](<screenshots/Screenshot (157).png>)

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

![alt text](<screenshots/Screenshot (158).png>)

---

### Notes

Answer the following in your own words:

**1. What is a function in Bash?**

A function is a named, reusable block of code that performs a specific task. Once defined, it can be called by name anywhere in the script instead of rewriting the same logic repeatedly.

---

**2. Why are functions useful in scripts?**

They make scripts more organized, readable, and maintainable by breaking complex tasks into smaller, self-contained pieces. They also let you reuse the same logic multiple times without duplicating code, and make it easier to fix or update one part without affecting the rest.


---

**3. Which functions did you create in this script?**

I created four functions: greet_user (personalized greeting), check_tools (loops through an array of required tools), check_file (validates whether a specific file exists), and check_score (evaluates a score using a conditional)

---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

Each function uses a different concept from earlier in the assignment: check_tools uses an array and a for loop, check_file uses an if conditional with a -f file test, check_score uses a variable and an if-else conditional, and greet_user uses a variable passed in as an argument. Wrapping all of this in functions and calling them in sequence shows how these building blocks combine into a single, organized automation script.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/andrew-ogunlana-70654ba7_devops-bash-linux-share-7485873254193270784-kT5k/?utm_source=share&utm_medium=member_desktop&rcm=ACoAABau_jYBg6kU-k2bFgLhNF2byWrnftwaanA

---

#### Screenshot — Published LinkedIn post

![alt text](<screenshots/Screenshot (159).png>)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [✅] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [ ✅ ] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [ ✅ ] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [ ✅ ] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [ ✅ ] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [ ✅ ] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [ ✅ ] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [ ✅ ] All scripts run without errors
- [ ✅ ] Full Name visible in all required screenshots
- [ ✅] LinkedIn post published and URL submitted
- [ ✅] No sensitive data exposed

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
# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on your system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

Add your screenshot here.

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is Bash?**

Add your answer here.

---

**2. What is the difference between shell and Bash?**

Add your answer here.

---

**3. Why is it important to confirm the Bash version before writing scripts?**

Add your answer here.

---

# Task 2 — Your First Bash Script

## Goal

Create your first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

Add your screenshot here.

---

#### Screenshot 2 — Output of `./first-script.sh`

Add your screenshot here.

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `#!/bin/bash`?**

Add your answer here.

---

**2. Why do we use `chmod +x` before running a script?**

Add your answer here.

---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

Add your answer here.

---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

Add your screenshot here.

---

#### Screenshot 2 — Output of `./user-info.sh`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is a variable in Bash?**

Add your answer here.

---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Add your answer here.

---

**3. How do you access the value stored inside a Bash variable?**

Add your answer here.

---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

Add your screenshot here.

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is an array in Bash?**

Add your answer here.

---

**2. Why are arrays useful in scripts?**

Add your answer here.

---

**3. What does `"${tools[@]}"` mean?**

Add your answer here.

---

**4. What is the purpose of the `for` loop in this script?**

Add your answer here.

---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

Add your screenshot here.

---

#### Screenshot 2 — Output of `./counter.sh`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is a loop?**

Add your answer here.

---

**2. Why do we use loops in Bash scripting?**

Add your answer here.

---

**3. How many times did the loop run in your script?**

Add your answer here.

---

**4. What would you change if you wanted the loop to run 10 times?**

Add your answer here.

---

# Task 6 — Files & Conditionals: File Validation Script

## Goal

Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

Add your screenshot here.

---

#### Screenshot 2 — Content of `file-check.sh`

Add your screenshot here.

---

#### Screenshot 3 — Output of `./file-check.sh`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What does `-d` check in Bash?**

Add your answer here.

---

**2. What does `-f` check in Bash?**

Add your answer here.

---

**3. Why should file and directory paths be stored in variables?**

Add your answer here.

---

**4. What happens if the file does not exist?**

Add your answer here.

---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

Add your screenshot here.

---

#### Screenshot 2 — Output showing `Result: Pass`

Add your screenshot here.

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`

Add your screenshot here.

---

#### Screenshot 4 — Output showing `Result: Retry`

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is the purpose of if-else in Bash?**

Add your answer here.

---

**2. What does `-ge` mean?**

Add your answer here.

---

**3. Why should conditions be tested with different values?**

Add your answer here.

---

**4. How can conditionals help in automation scripts?**

Add your answer here.

---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-automation.sh`

Add your screenshot here.

---

#### Screenshot 2 — Output of `./final-automation.sh`

Add your screenshot here.

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

Add your screenshot here.

---

### Notes

Answer the following in your own words:

**1. What is a function in Bash?**

Add your answer here.

---

**2. Why are functions useful in scripts?**

Add your answer here.

---

**3. Which functions did you create in this script?**

Add your answer here.

---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

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

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [ ] Task 1: Environment setup verified, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [ ] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [ ] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [ ] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [ ] All scripts run without errors
- [ ] Full Name visible in all required screenshots
- [ ] LinkedIn post published and URL submitted
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