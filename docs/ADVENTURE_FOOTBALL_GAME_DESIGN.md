# Adventure Football — First Playable Game Design

Last updated: 2026-11-26
Status: Design baseline for the first prototype. This is a specification, not a playable game or a final engine commitment.

## 1. Product promise

Adventure Football is an original, mobile-first 3D football game. Its long-term ambition is a polished, believable professional-football experience with responsive controls, intelligent play, convincing ball behaviour and strong match atmosphere.

The first milestone is deliberately smaller: a complete offline 5-vs-5 match that feels responsive and fun. Five-a-side is a development step toward a larger game, not a permanent limit on the product.

Use contemporary football simulations as broad quality references only. All names, branding, teams, kits, player identities, stadiums, art, audio, UI presentation and code must be original or properly licensed. Do not use EA branding, copied assets, unlicensed real-player likenesses or protected club marks.

## 2. First prototype boundaries

### Included in the first playable build
- One compact original 3D pitch and simple stadium environment.
- Two fictional teams, each with four outfield players and one goalkeeper.
- One local human-controlled team against offline AI.
- A controllable player, basic teammate support and AI opponents.
- Movement, sprint, turn, dribble, pass, shoot and player switching.
- Ball movement, ground friction, bounce, player collision and goal detection.
- Basic defensive positioning, pressure, interception and goalkeeper reactions.
- Kick-off, goals, restart, match timer, half-time/end state and scoreboard.
- Pause/restart controls and a simple settings panel.
- Touchscreen-first HUD with readable safe-area spacing.

### Explicitly deferred
Online multiplayer, matchmaking, clubs, chat/voice, tournaments, career mode, player transfers, monetisation, licensed leagues/players, commentary, crowds with detailed animation, refereeing complexity, fouls/cards/set pieces, weather, replay editor and 11-vs-11.

These are deferred until the core match works and performance is measured.

## 3. Match format and rules

- Format: 5 vs 5 — four outfield players plus one goalkeeper per side.
- Prototype venue: one compact rectangular pitch with clearly visible touchlines, halfway line, centre spot, penalty areas and goals.
- Match duration: short test match, initially two halves of three minutes each. This is a prototype tuning value, not a final competition rule.
- Kick-off: begin at centre; after a goal, the conceding side restarts.
- Ball out of play: use one consistent simple restart rule (kick-in or throw-in); decide during implementation after control tests.
- Goal: the whole ball crosses the goal line between the posts and under the crossbar.
- End: match ends when the timer expires; show final score and rematch action.
- No cash betting, gambling or pay-to-win mechanics.

## 4. Player roles and behaviour

Each team has:
- Goalkeeper: guards the goal, tracks ball position, moves laterally within a defined area and attempts a save when a shot threatens the goal.
- Defender: protects space in front of goal, closes down nearby attackers and attempts safe interceptions.
- Midfielder: supports the ball carrier, offers passing options and tracks back when possession is lost.
- Forward: looks for space ahead of the ball, makes simple runs and attempts shots when in a useful position.
- Fourth outfield player: role can be assigned dynamically according to possession and team shape.

For the first prototype, roles are simple behavioural priorities, not a complex tactical simulation. AI decisions should be readable and consistent: seek ball, mark/cover space, offer support, recover shape, receive pass or attempt a shot when appropriate.

## 5. Mobile control and HUD concept

Landscape orientation is the working assumption for the football match. Confirm this with a real-device prototype before locking it.

### Left side
- Virtual movement stick in the lower-left safe area.
- Responsive directional movement; diagonal movement should not be faster than straight movement.
- Optional short sprint modifier near the stick, with a simple stamina/cooldown tuning model only if needed.

### Right side
- Contextual primary action button: Shoot when in possession and in a shooting context; Tackle/Press when defending.
- Pass button when in possession.
- Sprint/skill action is secondary and must not crowd the screen.
- Switch-player button when defending.
- Buttons must be large enough for thumbs and spaced to reduce accidental taps.

### Top HUD
- Score and team abbreviations centred at the top.
- Match clock directly below or integrated into the score panel.
- Pause button in a top corner, clear of device cut-outs.
- Brief goal/restart message appears without blocking play.

### Camera
- Elevated broadcast-style oblique camera following play, keeping the ball and useful nearby players visible.
- Smooth camera movement with limited lag; avoid abrupt rotation or excessive zoom.
- Provide a camera sensitivity/height option only if inexpensive and testable.
- Camera must respect landscape safe areas and remain legible on smaller phones.

### Accessibility and comfort
- High-contrast score and controls.
- Optional vibration only if supported and user-enabled.
- Remappable or alternative control layout can follow after the first playable test.
- Avoid relying on colour alone to distinguish teams; use clear kit contrast and UI labels.

## 6. Gameplay systems

### Input and player movement
- Input is read separately from player movement logic.
- Movement should accelerate and decelerate smoothly, with responsive turning and sensible limits.
- Sprint trades speed for control/stamina only if the added complexity improves play.
- Animation state follows movement state (idle, jog, sprint, turn, tackle, pass, shoot, fall/recover).

### Ball simulation
- Use a physics-driven ball with tuned mass, friction, bounce and collision response.
- Passing and shooting apply controlled impulses with direction, power and elevation.
- Ball control/dribbling should feel attached enough for play but remain visibly physical; avoid a ball that appears magnetically glued to the player.
- Tune collision shapes and physics timestep to prevent tunnelling and unstable rebounds.
- Keep ball simulation deterministic enough for repeatable offline testing; online determinism is not a first-prototype requirement.

### Passing and shooting
- Pass selects a sensible teammate in the intended direction, while allowing directional aim.
- Pass power depends on input duration or a small set of tap/hold levels; choose the simplest reliable option during implementation.
- Shooting direction and power are influenced by player facing, distance and input.
- Add a modest accuracy penalty while moving quickly or under pressure; do not make outcomes feel random.
- Show a clear feedback cue for selected receiver/shot direction where needed.

### Defending
- Defenders approach the ball carrier while protecting the route to goal.
- Tackles require proximity and timing; avoid automatic possession theft from far away.
- Interceptions depend on player position and ball path.
- Teammates recover toward a compact shape after possession changes.

### Goalkeeper
- Track the ball and likely shot line.
- Move laterally within a defined goal area.
- Choose a basic save animation/response based on shot direction, height and distance.
- Do not guarantee a save or a goal; outcomes should be explainable by positioning and shot quality.
- First build can use simple procedural movement and placeholder animations.

## 7. Match flow and screens

1. Game Center card opens the Adventure Football information/launch surface.
2. Prototype launch opens a self-contained game view or build; no change to Adventure sign-in or registration is required for offline testing.
3. Main menu: Play Match, Controls, Settings, Back to Adventure.
4. Match setup: choose one of two fictional teams and a simple difficulty setting.
5. Pre-match: short countdown and kick-off.
6. Live match: pitch, players, controls, score and timer.
7. Goal: brief visual/audio feedback, score update and restart.
8. Pause: Resume, Restart Match, Controls, Exit.
9. Full time: result, basic match summary and Rematch.
10. Exit returns to Adventure through a documented launch boundary.

The first offline prototype must remain usable without an Adventure account or network connection.

## 8. Technical architecture principles

### Isolated game core
Keep gameplay code independent of Adventure Social. Suggested conceptual modules:
- GameBootstrap: starts the game and loads configuration.
- MatchState: kick-off, live, goal pause, half-time, full-time and restart.
- Input: maps touchscreen/controller input to gameplay commands.
- PlayerController: movement and action requests.
- PlayerState: possession, stamina if used, role and animation state.
- BallController: physics, possession interaction and goal/out detection.
- TeamAI: support, marking, pressure and shape recovery.
- GoalkeeperAI: goal tracking and save decisions.
- CameraRig: follows the play.
- MatchHUD: score, timer, controls and pause.
- Audio/Feedback: original temporary effects and haptics, later replaceable with licensed/original assets.

Use clear interfaces between these modules. Do not let gameplay objects query Adventure's Supabase tables directly.

### Integration boundary
Adventure Social should only need a small launch/return contract initially:
- Adventure launches the game surface/build.
- Game can receive a non-sensitive launch context if genuinely needed.
- Game returns to Adventure when the player exits.
- No social account token, private profile data or privileged backend credential is embedded in the game client.
- Account linking, achievements, friends and cloud saves are future designs requiring a separate security/privacy review.

### Standalone readiness
Keep the game project, assets, build settings and game-specific services in a separate project/folder/repository boundary when implementation begins. Avoid hard-coding Adventure page paths into the gameplay core. Put platform-specific launch/return behaviour in a small adapter layer.

## 9. Performance and device strategy

Do not promise a device tier before profiling a real build. First gather the available target phone models and test:
- Stable frame pacing, not just peak FPS.
- Touch input latency.
- Heat and battery use during a complete match.
- Memory use and loading time.
- Visibility and control usability on smaller screens.
- Performance under low-power conditions.

Start with modest geometry, simple lighting, limited transparent effects, small textures and a low-cost stadium. Increase visual quality only after a stable frame budget is demonstrated. The first prototype should favour responsive play over expensive crowd/stadium detail.

## 10. Prototype acceptance criteria

A build is not considered playable until all of the following are demonstrated:
1. It launches and runs offline.
2. A full match can start, play, end and restart without a crash or stuck state.
3. Touch movement is responsive and diagonal movement is correctly normalised.
4. Pass and shot actions produce distinguishable, controllable outcomes.
5. Ball collisions, bounce and goal detection work reliably in repeated tests.
6. AI players move with basic purpose, support their team and attempt to defend.
7. The goalkeeper reacts to shots and can make saves.
8. Score and clock remain correct through goals, pauses and restarts.
9. No game client dependency on Adventure Social's privileged data or authentication exists.
10. Performance and usability results are recorded for each actual test device.

## 11. Build phases

### Phase A — Design and feasibility (phone-friendly preparation)
- Complete this design baseline.
- Confirm a desktop/laptop development environment and specifications.
- Confirm target phone(s), landscape support and minimum device ambition.
- Re-check Unity licensing, install requirements, mobile build modules and integration route before locking the engine.
- Create a time/cost estimate. No spending without explicit approval.

### Phase B — Greybox prototype
- Basic pitch, simple capsules/placeholder players, ball, camera and controls.
- One controllable player and simple AI.
- Verify movement, ball physics and goal detection.

### Phase C — Complete 5-vs-5 loop
- Add teammates/opponents, goalkeeper, passing, shooting, score, clock, restart and match end.
- Test offline on actual phones.

### Phase D — Feel and presentation
- Improve animation blending, player responsiveness, camera, UI, sound and stadium.
- Replace placeholders only with original or licensed assets.

### Phase E — Expand only after evidence
- Improve AI and tactical behaviour.
- Consider 7-vs-7 then 11-vs-11 only if performance and gameplay tests support expansion.
- Consider online multiplayer after offline match quality, networking design, anti-cheat, moderation, hosting cost and support requirements are reviewed.

## 12. Current blockers and open decisions

- No desktop/laptop development environment has been confirmed; the owner is currently using an iPhone.
- Target phone models and minimum performance tier are not yet confirmed.
- Unity is the preferred candidate, not a final engine lock.
- The exact first prototype match length and restart rule are provisional tuning decisions.
- No playable code, 3D assets, game backend, multiplayer service or game build has been created.
- No paid tools, assets, hosting, services or licences have been approved.

## 13. Definition of done for the preparation stage

Preparation is complete when the owner-approved product direction, first playable scope, control concept, match loop, technical boundaries, acceptance tests, device requirements and cost/engine gates are documented. This document completes the first design baseline only; it does not mean the game itself is built or ready to launch.


## Browser greybox experiment — 2026-11-26

A separate experimental page, `football-prototype.html`, has been added at the repository root. It uses Three.js from a public CDN and creates a primitive 3D pitch, ten placeholder players, a ball, score/time HUD and touch controls for movement, passing, shooting, pressing and switching. It is a lightweight browser experiment to begin checking the match-camera and mobile-control concept from an iPhone.

Important limitations:
- This is a greybox experiment, not the Unity project and not the intended final game engine.
- Placeholder geometry is not realistic player art or animation.
- AI movement and ball interaction are rudimentary; this is not a complete or balanced football simulation.
- Three.js is loaded from jsDelivr, so the page requires an internet connection and a successful CDN load.
- The live GitHub Pages URL and actual iPhone WebGL/touch performance have not been verified. Source checks only confirmed the expected code sections are present.
- Do not connect this experiment to Adventure accounts, Supabase or production social features. Keep it isolated and disposable if the eventual Unity prototype supersedes it.
