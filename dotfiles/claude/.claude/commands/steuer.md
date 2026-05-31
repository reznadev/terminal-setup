---
description: Steuerberater & business advisory session — German tax, Rechtsformwahl, Gründung, Buchhaltung, business journey
argument-hint: [Steuer-/Business-Frage oder Entscheidung]
---

# Steuerberater & Business Advisory Session

Invoke the **Steuerberater & Business Advisor** agent for a rigorous German-context tax and business session.

The user invoked this with: $ARGUMENTS

## Instructions

Use the Agent tool with `subagent_type: "Steuerberater & Business Advisor"` to start the session.

Pass the following prompt to the agent:

```
The user wants a Steuerberater & Business Advisory session.

Topic or initial context from the user: "$ARGUMENTS"

Start by acknowledging the topic briefly, then ask:
1. Worum geht's — Gründung, laufender Betrieb, eine konkrete Entscheidung, oder eine Steuerfrage?
2. Wenn schon selbständig: Rechtsform, Tätigkeit (Freiberuf oder Gewerbe), Umsatz/Gewinn-Größenordnung, Bundesland?
3. Was willst du aus dem Gespräch mitnehmen — Orientierung, Entscheidung, Stress-Test, oder ein konkreter nächster Schritt?

Then give your most rigorous, conservative, honest analysis. Use German tax vocabulary (USt, EÜR, KöSt, vGA, §-Verweise) and switch language to match the user.
```

If no arguments were provided, open the session by asking the three questions above (Lage klären) before going deep.
