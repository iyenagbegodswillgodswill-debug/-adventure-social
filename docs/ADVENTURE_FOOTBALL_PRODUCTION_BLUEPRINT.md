# Adventure Football — Production Blueprint

Last updated: 2026-11-26
Status: Owner-approved direction and production preparation. This is a build blueprint, not a claim that a production game or Unity project exists.

## 1. Product standard

Adventure Football is intended to be a serious, realistic football simulation for players who enjoy competitive football. The quality reference is the broad feel and production ambition of modern console football games. The project must not be represented as a toy, casual arcade prototype, or finished game while it is still in development.

The quality target includes:
- Believable human footballers with original, coherent models, proportions, kits and facial/physical variation.
- High-quality locomotion and football animation: acceleration, deceleration, turning, sprinting, shielding, dribbling, passing, shooting, tackling, jumping, heading, falling and recovery.
- Responsive player control with weight, momentum and readable input response; responsiveness must not be sacrificed for visual spectacle.
- Convincing ball physics and player/ball interaction, including first touch, pass speed, shot power, spin/bounce where appropriate, deflections and goalkeeper contact.
- Football intelligence: team shape, support runs, marking, pressing, defensive recovery, passing choices, shot selection and goalkeeper positioning.
- Broadcast-quality match camera and clear, premium match presentation.
- A convincing stadium environment, lighting, pitch materials, sound and atmosphere, scaled to the actual device performance budget.
- Stable frame pacing, fast enough loading, readable controls and reliable operation on the agreed target devices.

These are acceptance goals to build toward, not features already delivered. Do not claim parity with a commercial console title unless measured evidence supports that claim.

## 2. Scope and release strategy

### First milestone
Build a complete offline 5-vs-5 vertical slice (four outfield players plus goalkeeper per side) to prove the core football loop. It is a production learning milestone, not the final product size.

### Later expansion
Only after the vertical slice passes gameplay and device gates:
1. Improve animation, player identity, ball behaviour and tactical AI.
2. Expand match size and tactical depth in measured steps, with 11-vs-11 as the long-term target.
3. Add deeper modes, team progression and competitions after the match itself is compelling.
4. Design and test online multiplayer as a separate major milestone with networking, anti-cheat, moderation, reliability and operating-cost review.
5. Keep the game capable of becoming a standalone title; Adventure Social integration must remain a narrow launch/return adapter.

### Not in the first vertical slice
Online multiplayer, public accounts, clubs, chat/voice, tournaments, career mode, transfers, monetisation, licensed leagues, real club badges, real-player likenesses, commentary and large-scale live operations.

## 3. Technology direction and decision gate

Unity is the preferred candidate, not a final lock. Before creating a production project, verify:
- The actual development computer and operating system available to the owner/development team.
- Current Unity licensing and terms for the intended use.
- Supported mobile build modules and the practical route for testing on the owner's iPhone.
- Rendering pipeline and performance feasibility for the target phone tier.
- Asset import, animation retargeting, physics and profiling workflow.
- How the standalone game build will be launched from Adventure without coupling the simulation to Adventure Social internals.
- Total cost of any required computer, software, assets, testing devices, hosting or specialist work.

Do not purchase, subscribe, upgrade, or accept paid terms without the owner's separate approval. If no suitable Windows or Mac development computer is available, stop before pretending the iPhone browser/GitHub workflow can replace a real game editor. Continue only with design, research, source control and low-cost planning until a proper development environment is available.

## 4. Production architecture

Keep the game project in its own repository or clearly isolated game project boundary. Keep simulation and game rules independent of Adventure Social.

Suggested layers:
- Core simulation: match state, rules, teams, player attributes, possession, ball state, scoring and time.
- Player control: human input, player movement, action selection and player switching.
- Animation: locomotion state machine, action state machine, blend spaces, animation events and foot/ball contact timing.
- Ball and physics: tuned rigid-body behaviour, controlled kicks, first-touch interaction, collision and goal detection.
- Team tactics and AI: formation, role assignment, support, marking, pressing, defensive line and decision evaluation.
- Goalkeeper: positioning, anticipation, dive/save selection, catch/parry and recovery.
- Presentation: camera, HUD, stadium, lighting, audio and match flow.
- Platform adapter: launch from Adventure, return to Adventure, platform input and optional non-sensitive launch context.
- Build and quality automation: reproducible builds, versioned assets, test scenes, performance captures and release checklist.

Do not embed Supabase service-role keys, database passwords, AI keys or other privileged credentials in the game client. Do not let gameplay objects query Adventure Social tables directly. Account linking and shared progression require a separate security design.

## 5. Art and content standards

- Use original characters, fictional teams, original kits and original stadium identity unless appropriate licences are obtained.
- Maintain an asset register containing creator/source, licence, permitted platforms, attribution requirements and proof of purchase/permission where relevant.
- Do not copy EA/FC branding, interface layouts, protected art, commentary, music, club marks or real-player likenesses.
- Greybox shapes may be used internally to test scale and mechanics, but must never be presented as the visual target or a finished player experience.
- Replace temporary models with properly rigged human characters and tested football animation before calling the visual milestone complete.
- Build a coherent art direction and quality bar before producing large quantities of content.

## 6. Development phases and exit gates

### Phase 0 — Feasibility and production setup
Deliver: confirmed development hardware, target devices, engine/licensing decision, project/repository structure, cost estimate, risk register and first vertical-slice backlog.
Exit gate: owner approves the technical plan and any spending. No production implementation is claimed before this gate.

### Phase 1 — Core control and movement
Deliver: one human-controlled rigged player, responsive movement, turning, sprinting, camera and touch/controller input; initial animation state machine.
Exit gate: movement feels controllable and believable in repeated hands-on tests, with recorded device performance.

### Phase 2 — Ball mastery and football actions
Deliver: ball physics, first touch, dribbling, passing, shooting, tackling and player/ball contact.
Exit gate: actions are repeatable, understandable and skill-influenced; no major tunnelling, stuck-ball or unreliable goal-line bugs in the agreed test suite.

### Phase 3 — Complete 5-vs-5 match
Deliver: two teams, goalkeeper, basic tactical AI, match clock, score, kick-off, goal/restart and full-time loop.
Exit gate: full match can be played offline from start to finish and repeated without critical defects.

### Phase 4 — Visual and audio quality
Deliver: original human player models, coherent kits, polished animation, pitch/stadium environment, lighting, sound and refined broadcast camera.
Exit gate: visual quality is consistent across the whole match, and performance remains within the agreed device budget.

### Phase 5 — Private playtesting and refinement
Deliver: structured tests with suitable adult football players, control/usability feedback, gameplay balance, crash/performance reports and prioritised fixes.
Exit gate: testers can complete matches, understand the controls and report that the core loop is enjoyable; critical bugs and severe performance issues are resolved.

### Phase 6 — Expansion and online feasibility
Only after the offline game passes: assess 7-vs-7/11-vs-11, multiplayer architecture, hosting, anti-cheat, moderation, privacy, support and recurring costs. Online play is not assumed to be a small add-on.

## 7. Quality and test evidence

For every milestone record:
- Build identifier, engine version and source commit.
- Device model, OS version, graphics settings and test conditions.
- Frame-time/frame-rate behaviour, memory, load time, heat and battery observations.
- Input latency and control usability.
- Match completion, restart and edge-case test results.
- Known defects and limitations.
- Playtest feedback, separated from developer assumptions.

A source file existing in GitHub, a web page loading, or a static screenshot is not proof that the game is playable. A milestone is complete only when its acceptance checks are demonstrated on the intended build and device.

## 8. Current prototype disposition

The existing root-level `football-prototype.html` is a primitive Three.js browser greybox experiment. It is not the production game, not a Unity project, not evidence of console-style visuals, and not the required playable milestone. Keep it isolated as a disposable reference for basic layout/control ideas. Do not spend further effort polishing its placeholder geometry as if it were the production route.

The Game Center may continue to label Adventure Football as in development. Do not advertise the prototype as a finished or playable game until a verified build passes the acceptance tests.

## 9. Immediate next actions

1. Confirm whether a suitable Windows or Mac desktop/laptop is available to run a real game editor. This is the immediate critical dependency.
2. Confirm the actual iPhone model(s) that should be supported and whether Android is also an initial target.
3. Complete a current engine/licensing/build-route comparison before locking Unity.
4. Create the isolated production project only after the hardware and engine gates pass.
5. Keep all work version-controlled and update `docs/PROJECT_STATUS.md` at every meaningful milestone.

## 10. Non-negotiable safeguards

- No paid purchases or recurring services without explicit owner approval.
- No unlicensed assets, brands, clubs, players, music or commentary.
- No weakening gameplay quality gates just to claim progress.
- No integration that risks Adventure Social authentication, database, registration or release settings.
- No claims of playability, realism, performance or completion without test evidence.
