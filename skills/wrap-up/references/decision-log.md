# Client decision log — format

For sessions where product, design, or technical decisions were made that the client should know about. Output to `docs/decisions/YYYY-MM-DD-<topic>.md` (create `docs/decisions/` if it doesn't exist).

## Capture per decision

- **What was decided** — the choice made
- **Alternatives considered** — what else was on the table
- **Why this choice** — connected to business goals, user needs, or stakeholder priorities. Reference stakeholders by name where relevant.

## Group by category

- **Strategy** — direction, scope, prioritization
- **Design** — layout, interaction, visual direction
- **Technical** — architecture, tradeoffs, framework choices that affect the product
- **Deferred** — features cut or postponed, with the reason

## Format for client readability

- No jargon, no internal tool names, no framework specifics
- Write as if the reader is a smart business person who cares about their product but doesn't code
- If professional reviews (CEO, eng, design) ran during the session, include a one-paragraph review summary

## Skip when

- Pure implementation with no decisions (just coding what was already decided)
- Internal cleanup or refactoring with no client-visible impact
