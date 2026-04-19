---
description: Investment analysis session with the Investment Advisor — portfolio strategy, equity analysis, personal finance
argument-hint: [investment question or decision]
---

# Investment Advisory Session

Invoke the **Investment Advisor** agent for a rigorous investment analysis session.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "Investment Advisor"` to start the session.

Pass the following prompt to the agent:

```
The user wants an investment advisory session.

Topic or initial context from the user: "$ARGUMENTS"

Start by acknowledging the topic briefly, then ask:
1. What's the specific question or decision — portfolio construction, equity analysis, asset allocation, personal finance, or macro?
2. Relevant context: time horizon, account type, tax situation, existing portfolio?

Then give your most rigorous, honest analysis.
```

If no arguments were provided, open the session by asking what investment question or decision the user wants to work through today.
