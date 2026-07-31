
# Reflection – Week 2
**By Andrew Ogunlana**

Week 2 of the DevOps Micro Internship was the point where "AI assistant" stopped feeling
like a chatbot and started feeling like a system I could actually configure, break, and fix.
Three topics stood out to me the most: Hooks & Permissions, and Memory.

## Hooks & Permissions
Building safety rails for Claude Code (Assignment 6) was the most humbling part of the week.
I wrote three hook scripts — one to block destructive prompts before Claude even processed
them, one to intercept dangerous terminal commands before they ran, and one to quietly log
Terraform activity afterward. On paper it seemed simple. In practice, my logging hook failed
silently for a while because a single missing tool (`jq`) meant every hook was quietly doing
nothing — and because the script didn't surface an error, I had no idea anything was wrong
until I went looking. That taught me a real lesson about defensive scripting: a script that
fails silently is more dangerous than one that fails loudly, because you trust it's working
when it isn't.

## Memory
Assignment 7 (teaching Claude to remember project facts across sessions) was the most
genuinely surprising part of the week. I expected memory to just mean "Claude repeats back
what I told it." Instead, when I asked a completely new question in a fresh session — without
repeating anything — Claude not only recalled the exact hex color codes I'd saved earlier, it
also proactively applied a second saved rule (TypeScript-only) I hadn't even asked about. That
was the moment agentic AI stopped feeling like autocomplete and started feeling like it was
actually reasoning with stored context.

## Challenges & Mindset
The biggest challenge wasn't the AI concepts themselves — it was my own environment. Working
across WSL and Windows filesystems, unstable Wi-Fi mid-push, and a missing dependency (`jq`)
all got in the way before I even got to test the actual assignment logic. It reinforced
something I keep relearning in this program: debugging your environment is just as much a
DevOps skill as writing the config itself.

## One Habit I'm Implementing
Going forward, I'm going to verify dependencies (`jq`, Terraform, etc.) *before* writing any
script that depends on them, rather than discovering the gap only after something fails
silently. A two-minute `--version` check up front would have saved me a debugging session.

Week 2 pushed me from "using AI to answer questions" toward "designing systems the AI operates
inside of" — and that shift is exactly why I'm here.