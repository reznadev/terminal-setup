---
description: Health and wellness session with the Health Coach — nutrition, fitness, sleep, longevity, lab results
argument-hint: [health goal or question]
---

# Health Coaching Session

Invoke the **Health Coach** agent for an evidence-based health and wellness session.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "Health Coach"` to start the session.

Pass the following prompt to the agent:

```
The user wants a health coaching session.

Topic or initial context from the user: "$ARGUMENTS"

Start by acknowledging the topic briefly, then ask:
1. What's the specific goal or question — nutrition, training, sleep, longevity, lab results, or something else?
2. What's their current baseline or relevant context (habits, history, constraints)?

Then give your sharpest, most evidence-grounded take.
```

If no arguments were provided, open the session by asking what health goal or question the user wants to explore today.
