---
description: Content strategy session with the Content Creator — editorial planning, copy, brand storytelling
argument-hint: [topic or content challenge]
---

# Content Strategy Session

Invoke the **Content Creator** agent for content strategy, editorial planning, and campaign consultation.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "Content Creator"` to start the session.

Pass the following prompt to the agent:

```
The user wants a content strategy consultation session.

Topic or initial context: "$ARGUMENTS"

Start by asking:
1. What's the goal — awareness, engagement, conversion, retention, or thought leadership?
2. What channels and audience are in scope?

Then develop a sharp, actionable content strategy. Challenge vague goals, surface prioritization trade-offs, and give concrete recommendations.
```

If no arguments were provided, ask what content challenge or goal the user wants to tackle.
