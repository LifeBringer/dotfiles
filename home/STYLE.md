---
name: style
role: Forward Deployed Engineer
version: 0.1
updated: 2026-11-10
companion: VOICE.md
---

# STYLE.md: what the user's writing must do, contain, and prove

This file governs argument, evidence, structure, and readiness for
anything written under the user's name. VOICE.md governs how the sentences
sound. A rule about wording, rhythm, or tone belongs in VOICE.md, not
here.

## Standards for every piece

Rules 1 and 2 apply to chat messages. All rules apply to anything
longer.

1. **Lead with the ask or the answer.** The first sentence says what
   the user wants or what he found.
2. **Make the ask actionable.** Say who does what, and by when.
3. **Back every claim.** Each claim has a number, a named system, a
   date, a link, or an example. Label each figure as measured,
   estimated, or assumed.
4. **Never invent.** Do not make up a number, a quote, a source, or a
   customer statement. If a fact is missing, ask the user or write it as an
   open question.
5. **Claim, mechanism, example.** After an abstract claim, say how it
   works, then give one concrete case.
6. **Answer the hardest question first.** State the reader's strongest
   objection in its strongest form, then answer it.
7. **Report what is not working and what is unknown.** A problem the
   reader finds alone costs more trust than one that the user names.
8. **One paragraph, one point.** The first sentence of the paragraph
   states the point.
9. **Say what is out of scope.** Name what this piece does not decide
   or cover.
10. **Removability test.** If cutting a paragraph would not change the
    reader's decision or action, cut it.

## Document types

| Type | Structure | Mode | Length |
|---|---|---|---|
| Quick ask in Slack | The ask, then one clause of context | Conversational | 1 to 2 lines |
| Status update | Status word (on track, at risk, blocked). What changed. Next step with a date. What the user needs. | Conversational | Under 10 lines |
| Risk or issue flag | What the user saw. Why it matters. What he recommends. What he needs. | Conversational | 2 to 5 sentences |
| Customer email | Purpose. What the customer gets or must do, with dates. Next step. | Conversational | Short paragraphs |
| Decision memo | Six sections, a premortem, an appendix | Conversational, narrative | 6 pages maximum |
| Proposal for something new | Press release, external FAQ, internal FAQ | Conversational | 3 to 4 pages |
| Runbook or how-to | Purpose. Prerequisites. Numbered steps. Expected result. Rollback. | Precise | As needed |
| Agent prompt, tool description, error message | Goal. Inputs. Rules. Output format. | Precise | As short as stays unambiguous |
| Incident summary | What happened. Impact. Cause with a confidence label. Fix. Prevention. Owner. | Precise | 1 page |
| PR description | What changed. Why. How to test. Risk. | Conversational | Under 15 lines |

## Decision memo

Use this when a decision has real stakes and the readers decide
together. If the input is too thin for a memo, say so and propose a
one-page note instead.

Form:

- Write the six sections in paragraphs. Bullets belong in the appendix.
- The memo stands alone. Assume the readers read it in silence at the
  start of the meeting and the user does not present.
- Six pages maximum for the six sections, about 2,700 words. If it
  does not fit, the thinking is not finished. The appendix has no
  limit.

Sections:

1. **Introduction.** What is proposed, why now, and the decision
   requested.
2. **Goals.** Three to five outcomes, each measurable and dated.
3. **Tenets.** Three or four decision rules that settle trade-offs
   without escalation. A tenet nobody could disagree with is a slogan.
   Rewrite it or cut it.
4. **State of the business.** Current facts with numbers, named
   systems, and dates. Include what is not working and what is
   unknown. History goes in section 5.
5. **Lessons learned.** Specific past events and what each one taught.
6. **Strategic priorities.** Three to five. Each has an owner, the
   investment, the expected impact with a metric and a date, and a
   named risk with its mitigation.

Premortem, in section 6 or the appendix: assume it is 12 months later
and the decision failed. Write the three most likely causes. Name the
signal the user will watch for each one.

Appendix: supporting data, and the alternatives considered with the
reason each was rejected.

Process: a memo for a high-stakes decision takes a week or more. Draft
it, share it for improvement, set it aside for a couple of days, then
edit it again. When the user asks for a memo in one pass, deliver the draft
and list which inputs were thin and what evidence would make it true.

## Proposal for something new

Work backwards from the customer.

1. **Press release, about one page.** Write it first, as if the thing
   has shipped: who it is for, the problem, the solution, how to get
   it.
2. **External FAQ.** What a customer would ask: what it is, how it
   differs from the obvious alternative, what it costs, when it is
   available, what it does not do.
3. **Internal FAQ.** What leadership would ask: why now, what success
   looks like with metrics and dates, dependencies, what we choose not
   to build, and what would make us stop.

If a credible press release cannot be written, the idea is not ready.
Say so.

## Precise-mode documents

Use Precise mode where the reader acts step by step and a wrong
reading has a cost.

Fit:

- Precise mode is flat on purpose. Do not use it for persuasion, for
  relationship messages, or for a risk discussion where the nuance is
  the content.
- It fixes form, not substance. A paragraph with nothing to say stays
  empty after the rewrite. Say so instead of polishing it.
- It is a layer under this file, not a replacement for it. The
  standards above still apply.

Content:

- A procedure states its purpose, its prerequisites, the numbered
  steps, the expected result, and how to roll back.
- One step holds one action. A warning or a condition comes before the
  step it applies to.
- Define each term that is not common English once, at first use. Add
  a glossary when a customer document has three or more such terms.
- For text an agent or a retrieval system will read, write one fact
  per sentence and one question per section. Practitioners report
  that retrieval works better on text written this way than on
  flowing prose.
- Keep every safety condition, exception, scope limit, and number from
  the source.

## Where rules meet

| Tension | Resolution |
|---|---|
| Narrative memo says no bullets. Precise mode says use lists. | Arguments go in paragraphs. Steps and conditions go in numbered lists. |
| A word limit would drop a condition | Keep the condition. Write two sentences. |
| One document holds both an argument and steps | Each part uses its own mode. Mark the steps with a heading. |
| Brevity against the full six-section memo | Match the form to the stakes. Most decisions need a short note, not a memo. |

## Readiness check

1. Can the reader act on the first sentence alone?
2. Does every ask have an owner and a date?
3. Does every claim have evidence, with figures labeled measured,
   estimated, or assumed?
4. Is the strongest objection stated and answered?
5. Does the piece say what is not working and what is unknown?
6. Does every paragraph pass the removability test?
7. Memo: do the priorities follow from the sections before them? Is
   the premortem specific?
8. Procedure: could a new teammate complete it without asking a
   question?
9. Customer-facing: no internal shorthand, no internal ticket numbers,
   no unreleased details.

## Never

- Invent data, quotes, sources, or customer statements.
- Hide bad news in the middle or the end.
- Pad a piece to reach a length.
- Send a customer-facing piece that the user has not approved. Drafting in
  his voice is not permission to send.

## Maintenance

- When the user changes what a draft argues, proves, or how it is ordered,
  record the rule here. Wording and tone changes go to VOICE.md.
- The document types and lengths are starting defaults. Replace them
  with the team's own templates where those exist.
- Basis: the Amazon narrative-memo practice described in Jeff Bezos's
  2017 shareholder letter and in public six-pager skills, the writing
  moves in his 2016 letter, and ASD-STE100 Issue 9 with its published
  limits.
