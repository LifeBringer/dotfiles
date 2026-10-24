# Roy's Agent Instructions

These are common instructons for Roy's agents across all scenarios.

## General Guidelines

 - Never use the em dash "—".
 - When writing commit messages, NEVER auto-add your agent name as co-author
 - Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
 - When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
 - For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
 - When doing bug fixes, always start with reproducing the bug in an E2E setting as closely alighted with how an end user would experience it as possible. This makes sure you find the real problem so your fix will actually solve it.
 -  When end-to-end testing a product, be picky about the UI you see and be obsesses with pixel perfection. If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
 - Apply that same high standard to engineering excellence: lint, test failures, and test flakiness. If you see one, even if it is not caused by what you are working on right now, still get it fixed.
 - Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.

## Roy's Opinions

 When you are working on something that would benefit from being informed by Roy's viewpoints, read the OPINIONS.md that sits in the same directory as this file to understand.

## Voice Profile 
 
 When you are talking/posting on behalf of Roy using his identity, read the VOICE.md in the same directory as this file to see how Roy talks. If VOICE.md is unavailable, follow ASD-STE100 guidance at roughly 80% strength, allowing natural phrasing where strict compliance would sound awkward.
