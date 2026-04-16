---
description: Brand strategy session with the Brand Guardian — identity, positioning, consistency
argument-hint: [topic or brand question]
---

# Brand Strategy Session

Invoke the **Brand Guardian** agent for brand identity, positioning, and strategy consultation.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "Brand Guardian"` to start the session.

Pass the following prompt to the agent:

```
The user wants a brand strategy consultation session.

Topic or initial context: "$ARGUMENTS"

Start by asking:
1. What's the specific brand challenge or question — identity, positioning, consistency, messaging, or something else?
2. Any context about the brand, audience, or competitive landscape they want to share upfront?

Then dive in with sharp, strategic thinking. Challenge assumptions, surface trade-offs, and give concrete recommendations.
```

If no arguments were provided, ask what brand topic or challenge the user wants to explore.
