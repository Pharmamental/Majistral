# Mobile Game UI/UX, Game Feel ("Juice") and Accessibility

Context: Flutter, portrait, bottom tab bar, cards on a wooden counter, "old pharmacy" style, learning game for pharmacy students. Research date 2026-10-27. Apple HIG pages render with JavaScript; only the `.md` endpoint of "Game controls" could be read in full. Other Apple numbers come from secondary sources and are flagged.

## 1. Touch ergonomics: thumb zones, one-handed play, touch targets, orientation, safe areas

### Takeaway
Put frequent actions in the bottom-centre thumb zone. Size primary targets at 44 pt (iOS) / 48 dp (Android) or larger, with 8 dp between targets. Menus and secondary controls can go higher and smaller (Apple allows 28 pt for games). Keep everything clear of the home indicator and the Dynamic Island.

### Cited Findings
- Hoober's 2013 street observation of 1,300+ people: 49% held the phone one-handed, 36% cradled it in one hand and tapped with the other, 15% used two hands. — [A List Apart / Smashing Magazine, "The Thumb Zone"](https://smashingmagazine.com/2016/09/the-thumb-zone-designing-for-mobile-users)
- Comfortable zone is bottom-centre, the stretch zone is mid-sides, and the top corners are hardest to reach. — [Smashing Magazine](https://smashingmagazine.com/2016/09/the-thumb-zone-designing-for-mobile-users)
- Counterpoint: the often-quoted "75% use one thumb" is misleading. Grips change constantly, so the thumb zone is a tendency, not a rigid map. — [Addy Osmani, "Modern Touch-Friendly Design"](https://addyosmani.com/blog/touch-friendly-design/)
- Apple, games (HIG "Game controls", updated 9 June 2025):
  - Frequently used controls should be at least 44×44 pt; less important controls such as menus at least 28×28 pt.
  - Place frequent buttons near the thumb and secondary controls (menus) at the top.
  - Respect safe areas, and don't overlap the Home indicator or Dynamic Island.
  — [Apple HIG Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls.md)
- Apple: "Always include visible and tactile press states." The press effect (e.g. a glow) should stay visible while the finger covers the control, combined with sound and haptics. — [Apple HIG Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls.md)
- Apple: prefer direct interaction with game objects ("tap objects to select them") over extra virtual buttons. Hide controls when an action isn't available, to cut clutter. Use symbols that show the action, not abstract shapes or names like "A/X". — [Apple HIG Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls.md)
- Android/Material: targets should be at least 48×48 dp with at least 8 dp between them (about 9 mm physically). The visible icon can be 24 dp if padding brings the touch area to 48 dp. — [Google Android Accessibility Help, Touch target size](https://support.google.com/accessibility/android/answer/7101858)
- The 48 dp / 8 dp figures trace back to a single Google source; most other spacing advice is vague. — [W3C low-vision TF thread](https://lists.w3.org/Archives/Public/public-low-vision-a11y-tf/2019Jan/0034.html)
- WCAG 2.2 AA floor is 24×24 CSS px (or 24 px spacing); 44 px is the AAA criterion. — [OpenReplay summary](https://blog.openreplay.com/improving-tap-targets-mobile-ux/)
- Game Accessibility Guidelines (GAG):
  - Basic: make interactive elements and virtual controls large and well spaced on touch screens.
  - Intermediate: make elements that need accuracy stationary; avoid holds, button-mashing and simultaneous gestures.
  - Advanced: allow both portrait and landscape.
  — [gameaccessibilityguidelines.com full list](https://gameaccessibilityguidelines.com/full-list/)

### Inferences
- For this project, the bottom tab bar plus "primary action at the bottom of the card" fits the thumb-zone evidence. The current 44 minimum matches iOS but is under Android's 48 dp. Raising tap areas (not the visible size) to 48 suits both platforms.
- The top wall area (fichets, headers) suits secondary navigation, consistent with Apple's "menus at top".
- Fichet tiles on the wall may be visually small, but each tap area should still be ≥44–48 with ≥8 spacing.
- Portrait-only is acceptable. Both orientations is an "advanced" GAG item, not basic.

### Gaps
- Apple's general Layout/safe-area page and Accessibility page could not be read (JS-rendered). The general iOS 44×44 pt minimum is confirmed only via secondary sources plus the games page.
- No source found for game-specific portrait-vs-landscape usage statistics.

## 2. Game UI patterns: HUD, bottom navigation, button hierarchy, modals, density, readability

### Takeaway
Show one primary action per surface, keep modals rare, short and unstacked, hide what isn't currently actionable, and make text meet XAG size and spacing minimums. Little authoritative, game-specific literature exists on hub screens or bottom tab bars. Most rules are borrowed from app design and console accessibility guidelines.

### Cited Findings
- Apple: present content modally only when there's a clear benefit, because a modal "takes people out of their current context and requires an action to dismiss". Keep modal tasks short, or people lose track of the task they suspended. — [Apple Modality (mirror)](https://glama.ai/mcp/servers/@tmaasen/apple-dev-mcp/blob/b82f0efe2115dc4539c83a2374a714a84aeb350a/content/universal/modality.md)
- Games: prefer reversible actions with undo over warning modals, because players learn to click through dialogs unread. — [Indieklem, "Best practices for modals in video games"](https://indieklem.substack.com/p/5-best-practices-for-modals-in-video)
- Don't stack an overlay on another overlay; finish or dismiss the first sheet. Stacked overlays confuse back-navigation. — [Dolfy, bottom sheet vs modal](https://www.dolfy.ai/blog/bottom-sheet-or-modal-mobile-interruption-pattern)
- Only one primary button, and no more than two buttons at the bottom of a mobile modal. — [Deliveroo design system, modals](https://design.deliveroo.net/components/tds/modals)
- Apple (games): show and hide controls to match gameplay context; combine related actions into one control (tap vs touch-and-hold) rather than multiple simultaneous buttons. — [Apple HIG Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls.md)
- XAG 101 minimum text body height (descender to ascender) on mobile: 18 px at 100 DPI, 36 px at 200 DPI, 72 px at 400 DPI, scaling linearly (a 5.5" 1080p phone is about 400 DPI). Text must scale to 200% without losing content and without two-axis scrolling. — [XAG 101 Text display](https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-101-text-display.md)
- XAG 101 rules for text blocks longer than two lines:
  - line spacing ≥1.5×
  - paragraph spacing ≥2× line spacing
  - line length ≤80 characters
  - letter spacing ≥0.12× font size
  - word spacing ≥0.16× font size
  — [XAG 101](https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-101-text-display.md)
- XAG 102 contrast:
  - 4.5:1 for standard text and visual elements
  - 3:1 for large text and inactive or disabled elements
  - 7:1 for every UI element in high-contrast mode
  - On non-solid backgrounds (e.g. wood grain), measure against the lowest-contrast part.
  - Avoid text baked into images.
  — [XAG 102 Contrast](https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-102-contrast.md)
- GAG Basic (cognitive):
  - let the game start without navigating through multiple menu levels
  - use simple, clear language and formatting
  - let players progress through text at their own pace
  - include interactive tutorials
  GAG Intermediate:
  - give a clear indication that interactive elements are interactive
  - allow reminders of current objectives
  - add contextual help
  — [GAG full list](https://gameaccessibilityguidelines.com/full-list/)

### Inferences
- Wood texture behind text or chips must be measured at its darkest/lightest grain point (XAG 102). Text should sit on paper or cards, not directly on wood, unless a high-contrast plate is behind it.
- The "Reçete" detail popup and the rush confirmation are justified modals (short, single purpose). Avoid chaining them. For the rush confirm, an undo-style reversible flow is an alternative worth testing.
- Bitter body text should be checked against XAG line and letter spacing for multi-line explanatory text (purpose / usedFor).

### Gaps
- No authoritative source found on bottom tab bars or hub-screen layout specifically in casual mobile games. Game UI Database (gameuidatabase.com) was not fetched, and is a reference library rather than a rules source.
- Material 3 layout pages were not readable (JS-rendered).

## 3. Game feel / juice: definition, techniques, evidence, risks

### Takeaway
Game feel (Swink) is real-time control plus polish: animation, sound and effects working together with input. "Juice" adds feedback beyond what's functionally needed. The best controlled study (Kao 2020) found medium and high juice beat both none and extreme juice. More is not better.

### Cited Findings
- Swink (2008, *Game Feel*): "real-time control of virtual objects in a simulated space, with interactions emphasised by polish". Polish is the impression of physicality created by the harmony of animation, sounds and effects with input-driven motion. Six areas: input, response, context, polish, metaphor, rules. — [Wikipedia: Game feel](https://en.wikipedia.org/wiki/Game_feel); [Liz England review](https://lizengland.com/blog/review-game-feel-by-steve-swink/)
- Real-time response means the feedback loop completes in under about 100 ms, roughly where lag becomes noticeable. — [Liz England review](https://lizengland.com/blog/review-game-feel-by-steve-swink/)
- Swink's definition is narrow. Pichlmair & Johansen's survey notes it doesn't cover all forms of game feel, and Doug Wilson distinguishes "Game Feel" (Swink's sense) from "game feel" in the broader sense. — [Designing Game Feel. A Survey (arXiv 2011.09201)](https://arxiv.org/pdf/2011.09201)
- "Juice it or lose it": Martin Jonasson & Petri Purho, May 2012, Nordic Game Jam/Conference (sources disagree on the venue; not a GDC talk). They live-added juicy effects to a Breakout prototype, about 15 minutes long. — [crcdng "Juicy Break"](https://crcdng.itch.io/juicy-break); [Quinnipiac course page](https://mywebspace.quinnipiac.edu/jbwarren/archive/2018-410/class-04.html)
- Jan Willem Nijman (Vlambeer), "The Art of Screenshake", worked example from one Nuclear Throne pistol shot:
  - camera kicked back 6 px
  - +4 screenshake that decays quickly
  - weapon sprite kick 2 that snaps back
  - first-frame round bullet as a fake muzzle flash
  - impact effect plus sound on hit
  - props (cacti) give "permanence" so battles leave traces
  — [infovore.org "Making Game Feel"](https://infovore.org/?p=5275); step-by-step recreation (muzzle flash, permanence, camera lerp, shake, hit pause, recoil) — [DK Liao devlog](https://dkliao.itch.io/the-art-of-screenshake-recreation/devlog/451576/quick-breakdown-of-all-the-effects)
- Hit-stop (brief freeze on impact): community guidance is 60–120 ms. This is not documented Vlambeer data. — [dev.to Godot hit-stop](https://dev.to/saltmire/godot-4-screen-shake-and-hit-stop-in-one-script-11eh)
- Evidence: Kao (2020, *Entertainment Computing* vol. 34) tested an action RPG at four levels (none, medium, high, extreme). Medium and high beat none and extreme on player experience, intrinsic motivation, play time and performance. Juice must fit the situation. Reported via the survey and secondary posts; the original paper was not read. — [Improbable Research](https://improbable.com/tag/rpg/); [arXiv 2011.09201](https://arxiv.org/pdf/2011.09201)
- Hicks, Gerling & Dickinson (2017) produced an empirically grounded definition of juiciness from a player and developer survey, and note that little academic work measures juice's actual effect. Hicks et al. 2024 (CHI PLAY) look at juicy audio, which is under-studied. — [Hicks slides, figshare](https://figshare.com/articles/Kieran_Hicks_Kathrin_Gerling_Patrick_Dickinson_-_What_makes_a_Game_Reflections_on_Juiciness_and_Player_Experience_/5147011); [Staffordshire profile](https://www.staffs.ac.uk/people/kieran-hicks)
- Too much juice can overwhelm and may lower intrinsic motivation. — [Juicy or Dry? (arXiv 2506.17011)](https://arxiv.org/pdf/2506.17011)
- Non-interactive decorative elements ("lushness") are a separate concept from juice. — Meiners, Reich, Hicks et al., FDG 2025, via [KIT library](https://publikationen.bibliothek.kit.edu/1000180225)

### Inferences
- The project rule "learning screen plain; celebration only at delivery" matches Kao's finding that extreme juice hurts. Apply juice to completions (delivery, step done, purchase), not to the thinking steps.
- Calm, card-based techniques are more suitable than action-game ones:
  - press-down on buttons (already chunky 3D)
  - eased card slides
  - small squash on star landing
  - paper-tape "settle"
  - a light haptic on confirmation
  Screenshake and hit-stop are of little use here except perhaps a tiny one for a wrong-tool reveal, and even that conflicts with the "no punishment" tone.
- "Permanence" can be translated as: finished prescriptions leave a visible trace (stamped stub, filled shelf).

### Gaps
- No primary transcript or slides of "Juice it or lose it" were read; its technique list (tweening, colour, particles, sound, eyes, etc.) is from memory and not cited.
- The Pichlmair & Johansen PDF could not be parsed (binary), so its technique taxonomy isn't cited in detail.
- No mobile- or education-specific juice study found.

## 4. Haptics guidelines (iOS / Android)

### Takeaway
Use short, crisp haptics for discrete confirmations. Scale strength with importance and inversely with frequency. Keep haptics in sync with visuals and sound, and use platform presets. On Android, no haptic is better than a buzzy one. Give an in-game haptics toggle (GAG).

### Cited Findings
- Android rules:
  - "less is more"; too much vibration is annoying and numbing, and users then switch all haptics off
  - very frequent events (scrolling) should be very subtle; important events stronger
  - the same effect for the same kind of interaction
  - prefer `HapticFeedbackConstants` and `VibrationEffect` primitives over custom one-shots
  - "Given the choice of buzzy haptics or no haptics for touch feedback, choose no haptics."
  — [Android Haptics design principles](https://developer.android.com/develop/ui/views/haptics/haptics-principles)
- Android timing: a good keyclick lasts 10–20 ms, but the actuator can ring another 20–50 ms, so avoid `createOneShot` for UI feedback. Haptics out of sync with visuals or audio feel unsettling and may seem broken. — [Android Haptics design principles](https://developer.android.com/develop/ui/views/haptics/haptics-principles)
- Clear haptic constants include CONFIRM, REJECT, LONG_PRESS, KEYBOARD_TAP, plus EFFECT_CLICK and EFFECT_TICK. Use one effect per input event. — [AOSP Haptics UX foundation](https://source.android.com/docs/core/interaction/haptics/haptics-ux-foundation)
- Apple (games): combine visual press state with sound and haptics. — [Apple HIG Game controls](https://developer.apple.com/design/human-interface-guidelines/game-controls.md)
- Flutter `HapticFeedback` provides `lightImpact` ("collision with a light mass"), `selectionClick` (selection changing through discrete values) and others. — [Flutter HapticFeedback class](https://api.flutter.dev/flutter/services/HapticFeedback-class.html). Per FlutterFlow, impact types need iOS 10+ and selectionClick needs Android API 23+. — [FlutterFlow haptic docs](https://docs.flutterflow.io/concepts/alerts/haptic-feedback)
- GAG Intermediate: include a toggle or slider for haptics. — [GAG full list](https://gameaccessibilityguidelines.com/full-list/)

### Inferences
- Map haptics as follows:
  - tab or tool selection: `selectionClick`
  - start job or confirm: `lightImpact`
  - delivery or 3 stars: `mediumImpact`, once
  - nothing on scroll or swipe of counter pages, or at most a very light tick on snap
- Add a haptics on/off setting when a settings screen exists.

### Gaps
- Apple's "Playing haptics" HIG page could not be read (JS-rendered). iOS-specific rules are only partly confirmed, via the Game controls page.
- No source found on whether iOS auto-suppresses app haptics when system haptics are off.

## 5. Game accessibility: GAG, XAG, colour-blindness, text size, motion, cognitive load

### Takeaway
For a mobile learning game, the most relevant items are:
- readable default text with scaling
- 4.5:1 contrast
- information never carried by colour alone
- no forced precise timing (or an alternative)
- no flicker, plus a way to turn off background motion
- simple language, self-paced text, practice without failure
- remembered settings

### Cited Findings
- GAG Basic, all categories, relevant items:
  - adjustable game speed
  - large, well-spaced controls
  - simple controls
  - avoid flicker and repetitive patterns
  - self-paced text
  - interactive tutorials
  - simple, clear language
  - readable default font size
  - high contrast
  - no essential info by colour alone
  - no essential info by sound alone
  - separate volume controls
  - save settings
  - wide choice of difficulty
  — [GAG full list](https://gameaccessibilityguidelines.com/full-list/)
- GAG Intermediate:
  - avoid held buttons, mashing and QTEs
  - practice without failure
  - reminders of current objective
  - contextual help
  - clear indication of interactivity
  - distinct sounds for key events
  - option to turn off background movement
  - haptics toggle
  GAG Advanced:
  - 0.5 s input cool-down option
  - "don't make precise timing essential" or offer alternatives
  - avoid sudden unexpected movement
  - adjustable font size
  - screen reader support
  — [GAG full list](https://gameaccessibilityguidelines.com/full-list/)
- XAG 102: red and green together commonly fail for colour-blind players. Pair colour with shape or text, offer selectable colours for key elements if colour must carry meaning, and check with a simulator such as Color Oracle. — [XAG 102](https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-102-contrast.md)
- Prevalence: about 8% of men and 0.4% of women of European descent have red-green colour vision deficiency. Deuteranomaly is the most common type. Rates vary by population (e.g. Tehran males 8.18%; one Indian study 8.73% M / 1.69% F). — [Kurdistan J Appl Res 2017](https://doaj.org/article/15749e000ad0485c8ae3210c0f099dea); [J Clin Diagn Res 2022](https://doaj.org/article/054cdcb82c8244988387b6bd782667c8); [Iranian J Public Health 2013](https://doaj.org/article/7251c725a9594c6cace0a907bd725f57)
- Flutter: `MediaQuery.disableAnimationsOf(context)` reports when the platform asks for animations to be reduced or turned off. — [Flutter API](https://api.flutter.dev/flutter/widgets/MediaQuery/disableAnimationsOf.html)
- Platform gap: one forum user reported that iOS Reduce Motion left the value false, while Android's "remove animations" set it true. A Flutter PR (#190287) proposes a separate `reduceMotion` field for iOS. Its merge status is unknown. — [itsallwidgets forum](https://forum.itsallwidgets.com/t/should-flutter-honor-ioss-reduce-motion-option-in-accessibility-settings/4657); [Flutter PR #190287](https://flutter.googlesource.com/mirrors/flutter/+/5b75e35fafa71ee952283051cc37b60f8e7a4f4b%5E)
- Reduced-motion practice: replace non-essential motion with immediate state changes or minimal fades. — [community Flutter skill note](https://tessl.io/registry/thiennc-tesoglobal/flutter-skills/0.10.0/files/skills/flutter-animation/references/motion-patterns-and-reduced-motion.md)

### Inferences
- The project already pairs colour with icon and text (status chips, check marks). The amber/green/purple/cobalt status set should be run through a deuteranopia simulator; amber vs green is the risky pair.
- The thermometer mini-game (keep 70–75°) is a precise-timing task. GAG Advanced suggests an alternative or a wider tolerance option. This fits the "no punishment" rule, where errors lower quality but never block.
- Card-slide and star animations should check `disableAnimationsOf`. Because of the iOS gap, an in-game "reduce motion" toggle is the safer path.

### Gaps
- Apple HIG Accessibility page (Dynamic Type sizes, Reduce Motion wording) could not be read directly.
- No source found quantifying cognitive-load limits (e.g. number of items per screen) for mobile games.

## 6. UX research methods for games (Hodent, GUR)

### Takeaway
Hodent splits game UX into usability (perception, attention, memory limits) and "engage-ability" (fun and motivation). For a small mobile team, the evidence points to heuristic evaluation plus playtesting (think-aloud), iterated with RITE.

### Cited Findings
- Celia Hodent, *The Gamer's Brain* (2017): Part II is a UX framework with chapters on Usability (ch. 11) and Engage-Ability (ch. 12), turned into a practical checklist. Usability is defined as considering human limits in perception, attention and memory. Hodent was Director of UX at Epic on Fortnite. — [Routledge](https://routledge.com/9781498775502); [Interaction 19 talk](https://interaction19.ixda.org/program/talk-the-ux-of-fortnite-celia-hodent/); [GDC Podcast ep. 8](https://www.gamedeveloper.com/design/games-psychology-and-ux-with-celia-hodent---gdc-podcast-ep-8)
- Think-aloud protocol (Lewis 1982), adapted to games: the player narrates while playing. It is one of the most data-rich methods. — [Kpi.fei.tuke gamedev lecture](https://kurzy.kpi.fei.tuke.sk/gamedev/en/lectures/testing.html)
- RITE (Rapid Iterative Testing and Evaluation): fix problems as soon as found, between sessions. It is widespread for fast-changing products like games. — [Kpi.fei.tuke lecture](https://kurzy.kpi.fei.tuke.sk/gamedev/en/lectures/testing.html)
- Heuristic Evaluation for Playability (Desurvire, Caplan, Toth, CHI 2004) is best for early prototypes and works alongside user studies. — [CHI 2004 paper](https://hci.rwth-aachen.de/materials/conferences/CHI2004/2p1509.pdf)
- Systematic review of mobile game playability (1,390 studies → 27 primary, 12 methods): heuristic evaluation and playtesting are most suitable for mobile games. — [Univ. Oulu thesis](https://oulurepo.oulu.fi/handle/10024/19184)
- GUR methods often need resources beyond small teams, and remote ad-hoc playtests are harder. — [Mitacs Star Salvager project](https://www.mitacs.ca/fr-ca/nos-projets/star-salvager-a-remote-games-user-research-toolkit-for-small-teams/)
- GAG: include players with impairments in playtests, and solicit accessibility feedback. — [GAG full list](https://gameaccessibilityguidelines.com/full-list/)

### Inferences
- Practical loop for this project: 3–5 pharmacy students per round, think-aloud on a phone, fix between rounds (RITE), and a heuristic pass against this checklist (touch size, contrast, colour, motion, modal count) before each round.

### Gaps
- Hodent's individual usability pillars (signs and feedback, clarity, form follows function, consistency, minimum workload, error prevention/recovery, flexibility) are recalled from memory and were not confirmed by any fetched source.
- The IGDA Games User Research SIG's own resources were not fetched.
