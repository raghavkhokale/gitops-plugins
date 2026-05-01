## Workflow A: Information retrieval

Follow every phase in order. Never skip A2–A4 and go straight to answering.

### Phase A1 — Classify the question

Determine what kind of fact the user wants. The kind determines which row in the source-of-truth matrix applies. Ask yourself: is this about a customer's identity/region/version? A live resource state? A specific CSR override? A Jira ticket? An org-wide search? Each kind has exactly one authoritative source — pick the right row before doing anything else.

### Phase A2 — Look up the authoritative source in the source-of-truth matrix

Consult the "Source-of-Truth matrix" section in "Universal rules" below. Find the row whose "kind of fact" matches what the user needs. That row specifies both the authoritative source and the exact MCP tool to use. Do not read from a different source on grounds of convenience or familiarity — the matrix is binding. If the kind of fact doesn't appear in the matrix, halt and ask the user what source they want you to consult.

### Phase A3 — Retrieve via the cheapest authoritative path

Call the tool from the matrix row. Pass the minimum arguments needed (customer, env, path — as specific as possible). For CSR reads, always use `csr_read` at `origin/<env-branch>` — never read from a stale local checkout. For Glean, use the most specific search query possible rather than broad org-wide searches. Record the exact tool call, arguments, and relevant return fields — these become your citations.

### Phase A4 — Cross-reference (if multiple sources answer the same question)

When more than one source could answer the same fact, verify they agree. If they disagree, surface the conflict explicitly: state which source says what, which source is more authoritative (per the matrix), and what action you recommend. Never silently prefer one answer over another. Empty results count as valid evidence — record "no match" explicitly rather than falling back to an assumption.

### Phase A5 — Halt and ask if info is insufficient

If the authoritative source is the live cluster and the cluster category is disabled, you cannot answer from memory or cross-customer patterns. Follow the "Halt and ask when info is incomplete" rule in Universal rules: state what's missing, show what you did find, and provide a complete paste-ready kubectl/tsh command derived from your CSR discoveries. End the turn and wait.

### Phase A6 — Respond with citations

Structure your response per the "Structured response shape" in Universal rules. Every fact must include a citation tracing back to the tool call and return field. Confidence must be labeled HIGH / MEDIUM / LOW per the definitions in that section. Do not claim a fact without a citation — use "Needs verification" grouping instead.
