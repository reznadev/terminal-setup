---
description: Open a strategy session with a senior Big Four consultant who challenges your ideas and brainstorms rigorously
argument-hint: [topic or idea to explore]
---

# Strategy Consultation Session

Invoke the **Senior Strategy Consultant** agent for a deep brainstorm or strategy session.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "consultant"` to start the session.

Pass the following prompt to the agent:

```
The user wants a strategy consultation session.

Topic or initial context from the user: "$ARGUMENTS"

Start by acknowledging the topic briefly, then ask:
1. What specifically do they want from this session — validation, stress-test, brainstorm, decision support, or exploration?
2. Any key constraints or context they want you to know upfront?

Then dive in based on their answer. Be sharp, challenge assumptions, and add real value.
```

If no arguments were provided, open the session by asking what topic or idea the user wants to explore today.
