# Mobile game onboarding (FTUE) and retention design

Context: notes for an educational, timed mobile game for pharmacy students (prescriptions arrive, the player sets up the preparation, jobs finish in real time). Research date: 2026-10-27. Most sources are industry reports and vendor blogs. Peer-reviewed evidence is thin and flagged where used.

## 1. Current D1/D7/D30 retention benchmarks by genre and platform

### Takeaway
Retention keeps falling. GameAnalytics' 2025 data (published 2026) puts the median mobile game at under 4% on D7 and about 0.7-0.8% on D30, with top-quartile games at D1 of just over 30%, D7 of 6-7% and D30 of 1.6-1.8%. Puzzle, match and board/card games hold players best over the medium and long term. Education apps sit near the bottom on D30 (around 2% in one dataset), though benchmarks swing a lot with methodology.

### Cited Findings
**GameAnalytics 2026 report (2025 data; 16,262 mobile games with at least 1,000 MAU; iOS and Android combined; all genres aggregated)** — [GameDevReports summary, Jun 2026](https://gamedevreports.substack.com/p/gameanalytics-mobile-and-pc-game)
- D1: top 25% "just above 30%"; top 10% at 40%; top 1% at 64-68%. D1 fell from 2024.
- D7: median "just under 4%"; top 25% at 6-7%; top 10% at 11-12%; top 1% above 25% (up to 28%).
- D30: median 0.69-0.79%; top 25% at 1.6-1.8%; top 1% at 13-15%.
- Mobile session length: top 25% about 5.2 min; top 10% 8 min; top 1% about 22 min. Sessions per day: top 25% 5.3-5.7; top 10% about 9.6.
- For comparison, PC median session length is 18 min.

**GameAnalytics 2025 report (2024 data; 11,600 apps, 16 genres, 9 regions; classic, not rolling, retention)** — [GameDevReports summary, Feb 2025](https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks)
- D1 top 25%: 26.48-27.69%, down from 28-29% in 2023. Bottom 25%: 10-11.5%.
- Platform split, D1 top 25%: iOS 31-33%, Android 25-27%. iOS retains better than Android.
- D7 median: 3.42-3.94%, down from 4-5% in 2023. Top 25%: 7-8%.
- 75% of projects have D28 below 3%.
- Median session 5-6 min; top 25% at 8-9 min.
- By genre, in words only (the numbers are in charts I could not read): arcade leads on D1 but is weak long term; board, card, puzzle and casino are best over the medium and long term.
- The full PDFs with genre tables are on investgame.net ([2025](https://investgame.net/wp-content/uploads/2025/02/2025-GameAnalytics-Mobile-Gaming-Benchmarks.pdf), [2026](https://investgame.net/wp-content/uploads/2026/01/2026-01-27-2026-mobile-pc-benchmarks_compressed.pdf)), but their genre charts are images I could not extract.

**Adjust Gaming App Insights 2026 (Jan 2024-Jan 2026, top 5,000 apps, 23 genres)** — [GameDevReports summary](https://gamedevreports.substack.com/p/adjust-gaming-app-insights-report)
- D1 across all genres was 27% in 2025.
- Family games rose from 18% to 23% D1, the biggest genre gain.
- Hypercasual and hybrid-casual have the highest D1; no figure given.
- Day-zero sessions averaged 1.65 in 2025.
- The summary author notes that top games "regularly exceed 40-50% D1." This is commentary, not Adjust data.

**Genre table (Mistplay data, as cited by a vendor blog; data year unstated)** — [Segwise blog, updated Jul 2026](https://segwise.ai/blog/mobile-gaming-app-user-retention-strategies.md)

| Genre | D1 | D7 | D30 |
|---|---|---|---|
| Match | 32.65% | 13.98% | 7.15% |
| Puzzle | 31.85% | 12.18% | 5.35% |
| Simulation | 30.10% | 8.71% | 2.96% |
| Hyper-casual | 29.31% | 5.90% | 1.38% |

- Mistplay's sample comes from a reward-play network, which likely skews retention upward. The same page cites Business of Apps 2026 medians of about 22% D1, 4% D7 and under 1% D30.

**Education apps (non-game benchmarks)**
- Business of Apps puts education at about 2% on D30, among the lowest of any category. AppsFlyer is cited at 2.1%. OneSignal's 2024 data shows Education at 8.02% on D30, against a cross-category 28.29% D1, 17.86% D7 and 7.88% D30. Seen via [search results incl. Business of Apps](https://www.businessofapps.com/?p=98187) and [Phiture](https://phiture.com/mobilegrowthstack/managing-retention-rate-benchmarks-and-expectations/). I did not open the primary reports.
- PocketGamer.biz (via a Supersonic talk) calls 45% D1 a strong sign the FTUE is on track — [PocketGamer.biz](https://www.pocketgamer.biz/first-impressions-count-creating-the-ultimate-first-time-user-experience). This is a practitioner rule of thumb, seen in a search snippet only.

### Inferences
- Realistic targets for a niche educational simulation: D1 of 30% or more puts it in the top quartile, and 40% is excellent. D7 of 6-8% or more is top quartile. D30 above 2% beats both the education and the median game benchmarks.
- A captive audience of students in a course would probably beat these organic-install benchmarks. These benchmarks mostly come from paid user acquisition, which dilutes intent.
- Simulation keeps players about as well as puzzle on D1 but loses them faster by D30. Long-term hooks (collections, a progression goal) matter more for this genre.
- Report retention as classic (returning on exactly day N), the way GameAnalytics does. Rolling retention gives higher numbers that are not comparable.

### Gaps
- I could not get genre-specific D1/D7/D30 numbers from GameAnalytics or Adjust in readable form; the charts are images.
- I found no separate benchmark for educational *games*, as distinct from education apps.
- I found no iOS vs Android split in the 2026 GameAnalytics data, which combines the two platforms.

## 2. FTUE best practice: time to fun, learning by doing, progressive disclosure, forced vs optional, first session length

### Takeaway
Industry consensus: show the core mechanic within the first minute. Teach by doing, through a short linear tutorial with clear goals, not text walls and not unguided freedom. Introduce UI and systems one at a time as they become relevant. Hold back friction (sign-ups, permissions, ads, extra currencies) until the player is hooked. End the first session on a designed moment of joy plus a visible next goal. Measure step-by-step drop-off and A/B test single steps.

### Cited Findings
- **Show the core mechanic as fast as possible.** Simple games need shorter tutorials; more complex hybrids need more time to layer systems — [Supersonic, "7 ways to optimize your FTUE", Mar 2025](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Case study, Trash Tycoon (Supersonic):** introducing mechanics too fast caused "60% churning during the tutorial." The fix was to teach one core loop first, then give each major unlock its own focused mini-tutorial — [Supersonic](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Case study, Trash Tycoon (Supersonic):** an opening with up to a minute of free play without instructions caused confusion and churn, because players did not understand their goals. The team moved to a more linear tutorial with clear goals — [Supersonic](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Progressive disclosure:** "Don't overwhelm players with lots of buttons up front." Add UI elements as their mechanics are introduced, and highlight new ones with tap-finger or arrow cues — [Supersonic](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Early tutorial details:** removing a single step or click can "have a big impact on player retention." Give every player the same tutorial ("the tutorial isn't the time to segment your users"). Keep early levels achievable and add friction gradually. Celebrate early wins. Do not oversupply currency. Hold ads until players are hooked — [Supersonic](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Time-to-fun targets:** reach core gameplay within about one minute; a "this is fun" moment after more than 90 seconds is a retention risk. Defer account creation, permissions and settings until after the first play. Measure step-level drop-off, not overall completion (for example, "12% of users leave at step three"). Vendor blog; its claim of "up to 50%" retention lift is unverified — [Playio blog](https://blog.playio.co/mobile-game-onboarding-retention)
- **Roblox official design docs:**
  - New players decide within minutes whether they like a game.
  - Teach controls and the core loop (what to do and why).
  - Funnel every onboarding step, and A/B test single steps (for example, a short dialogue versus a guided arrow).
  - Keep early XP thresholds low so the first level-ups come fast.
  - Give enough starter currency to engage players with your systems, but not so much that it kills the incentive.
  - Show short-, mid- and long-term goals.
  - End onboarding with a designed moment of joy (reward, animation, celebration).
  - [Roblox Creator Docs: Onboarding](https://create.roblox.com/docs/production/game-design/onboarding)
- **Celia Hodent (The Gamer's Brain, CRC Press 2017; GDC 2016 "UX of Onboarding and Player Engagement"):** advocates learning by doing, in a context that makes sense to the learner, with the tutorial folded into the game itself. Her pitfall examples come from Fortnite — [Game Developer](https://gamedeveloper.com/design/video-inside-the-ux-of-onboarding-and-player-engagement); paraphrase via a [secondary Medium piece](https://medium.com/p/5ec8362b34c3). I did not get the talk transcript.
- **Academic:** "Identifying Onboarding Heuristics for Free-to-Play Mobile Games: A Mixed Methods Approach" (IFIP) derives onboarding heuristics from puzzle, base-builder and arcade titles. It stresses that the first few minutes decide retention — [IFIP DL](https://dl.ifip.org/hal-01640269v1). The page timed out, so I could not extract the heuristic list.
- **Pop-ups and next goals:** too many pop-ups in the FTUE break immersion and drive early exits. Plant future rewards and a clear next goal in the FTUE — [PocketGamer.biz, PGC Digital talk](https://www.pocketgamer.biz/pgc-digital-how-to-enhance-the-first-time-user-experience)
- **First-session reference points:** median mobile sessions run about 5-6 minutes and top-quartile sessions about 8-9 minutes ([GameAnalytics 2024 data](https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks)). Players average 1.65 sessions on day zero ([Adjust 2026](https://gamedevreports.substack.com/p/adjust-gaming-app-insights-report)).

### Inferences
- **Fit for this game:** a real-time job loop risks a first session where the player starts a preparation and then has nothing to do. The FTUE should make the first job complete quickly (very short timers, or a guided first job that finishes inside the session) so the player sees the full prescription → preparation → delivery loop, including the reward, in session one. Longer real-time waits come in only after the first loop.
- Teach one station or tool per job, unlocking more as prescriptions demand them. This mirrors the Trash Tycoon fix of core loop first, then a mini-tutorial per unlock.
- Do not open with free exploration or text explanations. Use a short linear guided first prescription with arrow or finger cues.
- Before the first session ends, have the player start a second job that finishes later. That gives them a concrete reason to come back (a natural appointment), plus a celebratory delivery moment.
- Aim for a first session of about 5-8 minutes, matching median to top-quartile mobile session lengths.

### Gaps
- I found no rigorous A/B data comparing forced versus skippable tutorials on mobile. Sources only say linear and guided beat unguided.
- I found no hard benchmark for target tutorial completion rate or ideal first-session length specific to educational games.

## 3. Long-term retention mechanics, and which are criticized as manipulative

### Takeaway
Daily goals, streaks, progression, collections and appointment-style returns are proven retention levers. Duolingo's own data shows that a *low-barrier* streak beats a demanding one. The same mechanics, when they rely on loss aversion (streak loss, withering, FOMO timers, guilt-trip notifications), are named dark patterns. Early evidence suggests they raise short-term retention but damage trust and long-term satisfaction.

### Cited Findings
**Duolingo experiments** — [Duolingo blog, "Improving the streak", Nov 2020](https://blog.duolingo.com/improving-the-streak)
- Learners on a 7+ day streak were 2.4x more likely to return the next day.
- Decoupling the streak (one lesson extends it) from the daily goal increased learners on 7+ day streaks by over 40%. In the A/B test it gave D14 retention +3.3% (relative), daily active learners +1%, and +19% streaking daily learners among new users.
- Over the following year, the share of daily learners holding a 7+ day streak rose from about a third to just over half.
- Learners on the "intense" goal setting were least likely to hold a streak.
- Lesson stated in the post: lowering the daily barrier matters more early on than how much people study; "we can't teach people if they stop using Duolingo."

**Further Duolingo reporting:** its retention PM calls the streak the most impactful feature, with 600+ streak experiments in four years — [Lenny's Podcast summary](https://www.recall.it/summary/lennys-podcast/behind-the-product-duolingo-streaks-or-jackson-shuttleworth-group-pm-retention-team). Secondary summary.

**Streak screens spreading:** found in 6.8% of captured apps in 2023, peaking at 14.0% in 2024 and falling to 8.1% in 2025. Convenience sample — [Lazyweb, 2026](https://www.lazyweb.com/research/are-streaks-still-spreading-beyond-duolingo)

**Criticism of streaks:** opinion piece, not empirical. Argues streaks run on loss aversion, so people log in when they do not want to study. Calls streak freezes and repairs "commitment escalators" and guilt-trip notifications "unmistakably manipulative" — [Atticus Li blog](https://atticusli.com/blog/posts/duolingo-skinner-habit-loop-variable-reinforcement-behavioral-economics/)

**Daily rewards and appointment mechanics:**
- GameRefinery found daily gift systems in all categories among the top 200 US iOS grossing games. Casual titles refresh at 24 hours or less; mid-core titles use 48-hour or weekly cycles. Escalating consecutive-day rewards (Dragon City) help retention — [Game World Observer / GameRefinery](https://gameworldobserver.com/2019/06/10/appointment-mechanics) (2019, older data).
- A GameAnalytics/GameRefinery piece frames a daily return reward as best practice and *wither* (losing progress if you don't return) as not — [GameAnalytics blog](https://www.gameanalytics.com/blog/appointment-mechanics-how-to-keep-your-players-in-game)
- Michail Katkoff (Deconstructor of Fun) observes that casual games (Hay Day, FarmVille) abandoned withering, while mid-core games (Boom Beach, Clash of Clans) kept it — [PocketGamer.biz](https://www.pocketgamer.biz/how-f2p-designers-should-balance-wither-and-daily-rewards)

**Dark pattern research:**
- **Zagal et al. (2013)** is the foundational taxonomy, covering temporal, monetary and social dark patterns. The temporal category includes "playing by appointment". Cited via [Niknejad et al., arXiv 2412.05039, Dec 2024](https://arxiv.org/html/2412.05039v1)
- **Niknejad et al.** analyzed user-generated data on 1,496 mobile games and found dark patterns even in games perceived as benign — [arXiv](https://www.arxiv.org/abs/2412.05039)
- **Spanish mixed-methods study:** surveyed 927 gamers aged 16-25. Its expert panel identified 25 dark patterns in 8 categories, including play-by-appointment and FOMO — [Index Comunicación](https://indexcomunicacion.es/index.php/indexcomunicacion/article/download/2387/2396/32780). Abstract only.
- **University of Vienna master's thesis:** a 30-day test of two game versions, with and without dark patterns. Dark patterns raised short-term retention and spending but lowered long-term satisfaction and trust; daily rewards and appointment play drew frustration and a feeling of being manipulated — [univie thesis](https://utheses-gateway.univie.ac.at/api/document/get/file/73970). Student thesis; preliminary.

### Inferences
- **Safe levers for this game:**
  - Low-barrier daily goal: one prescription delivered counts.
  - Collections: a formulary or recipe book of preparations mastered, which also serves the learning goal.
  - Progression: station and equipment tiers, and harder prescriptions.
  - Natural appointments: real-time jobs finishing.
- **Avoid:**
  - Withering or penalties for not returning (already ruled out by the project's "no penalty, product never spoils" rule).
  - Guilt-trip notifications.
  - Paid or ad-gated streak repair.
  - Expiring FOMO offers.
- A streak, if used, should be forgiving (one action per day, free freezes) and kept separate from any harder daily goal, following Duolingo's finding.
- For a learning game, the retention mechanic should reinforce practice (spaced repetition of preparations) rather than compulsive check-ins.

### Gaps
- I found no peer-reviewed RCT isolating the effect of streaks or daily rewards on game retention. Duolingo's data is company self-report.
- I did not search for regulatory guidance on these mechanics (EU CPC 2025 principles on virtual currencies, UK CMA/ASA).

## 4. Why players quit in the first minutes and days (teardowns and analyses)

### Takeaway
The recurring causes, mostly from vendor and practitioner analyses:
- Long or confusing tutorials, unclear goals, too many mechanics or currencies at once.
- A late hook (no fun moment early).
- Early pop-ups, ads and monetization.
- Difficulty spikes, crashes and long loads.

A second wave quits after the tutorial or around day 3, when the game shows no meaningful next goal.

### Cited Findings
- **Trash Tycoon:** 60% churned *during the tutorial* because mechanics came too fast; unguided early freedom also caused churn — [Supersonic](https://supersonic.com/learn/blog/optimizing-ftue/)
- **Commonly cited causes:** overly long tutorials, confusing UI, unclear goals, slow ramp-up to fun, difficulty spikes, aggressive ads, crashes. Players who lose track of their goals quit right away — [80.lv](https://80.lv/articles/how-to-solve-player-drop-off-in-modern-mobile-game-design); [Udonis](https://blog.udonis.co/mobile-marketing/mobile-games/churn-rate)
- **Late hook:** if playtesters are neutral through the first ten minutes, the fix is an earlier hook, not more hand-holding — [VGM blog](https://vgm.co/blog/what-your-day-30-drop-off-is-actually-telling-you-about-your-game-s-first-hour)
- **Delayed churn:** some players finish the tutorial and never return, so D1 looks fine while D7 collapses; check both together — [Scoop Analytics](https://www.scoopanalytics.com/blog/why-do-mobile-players-love-my-game-for-3-days-then-delete-it)
- **Tutorial funnel signal:** GameAnalytics flags a sharp drop between tutorial start and tutorial completion as the key signal — [GameAnalytics](https://gameanalytics.com/?p=4612)
- **Pop-ups:** too many in the FTUE break immersion and drive early exits — [PocketGamer.biz](https://www.pocketgamer.biz/pgc-digital-how-to-enhance-the-first-time-user-experience)
- **Analytics limits:** funnels show *where* players leave but not *why*; watching real players is irreplaceable — [80.lv](https://80.lv/articles/how-to-solve-player-drop-off-in-modern-mobile-game-design)
- **Unsourced statistics:** some widely repeated figures ("60% abandon after tutorial in a study of 100 games", "73% churn within 24 hours") have no traceable source. Do not cite them.

### Inferences
- **Risks specific to this game:**
  - Real-time waits in session one, so the player starts a job and has nothing to do.
  - Too many stations or tools introduced together.
  - Pharmacy content shown as text (quantities, roles) before the player has done anything.
  - No visible next goal after the first delivery.
- Instrument at minimum: app open → first prescription opened → first job started → first job delivered → second job started → session 2. Watch 5-10 pharmacy students play the first session.

### Gaps
- I found no public teardown specific to educational or simulation games. Deconstructor of Fun teardowns found in this pass focused on mid-core and casual F2P.

## 5. Re-engaging lapsed players: comeback rewards and notifications

### Takeaway
Behavior-triggered, relevant pushes (your job is ready) outperform mass sends. Common practice is a few re-engagement pushes over 30-60 days, starting 3-14 days after the last session, often with a comeback reward. Guilt-based messaging drives opt-outs. Independent data is scarce; most figures are vendor claims.

### Cited Findings
- **Pushwoosh (vendor claims):** behavior-triggered pushes reach 14% CTR versus 2-3% for mass sends; up to 26% churn reduction among at-risk users — [Pushwoosh](https://www.pushwoosh.com/products/pushwoosh-for-gaming-apps/). Self-reported.
- **Countly:**
  - Send the first re-engagement push after 3-14 days of inactivity; companies typically send 3-5 pushes over 30-60 days.
  - Recommends comeback bonuses and advises against guilt messaging because it drives opt-outs.
  - Cites Localytics: 65% of users with push enabled return within 30 days, versus 20% without. App-wide figure, secondary, and likely confounded by self-selection.
  - [Countly blog](https://countly.com/blog/how-to-use-push-notifications-to-bring-lapsed-players-back-to-your-game)
- **Appointment pushes:** escalating consecutive-day rewards and daily gift refresh cycles are standard — [GameRefinery via Game World Observer](https://gameworldobserver.com/2019/06/10/appointment-mechanics)
- **Duolingo's guilt-trip notifications** are criticized as manipulative — [Atticus Li](https://atticusli.com/blog/posts/duolingo-skinner-habit-loop-variable-reinforcement-behavioral-economics/). Opinion.

### Inferences
- Real-time jobs give an honest, high-relevance trigger ("Your cold cream is ready to deliver"). This is the behavior-triggered type that performs best, and it avoids manipulation.
- Comeback reward: a non-punitive welcome-back gift (for example, a free rush or currency) after several days away fits the project's "no penalty" rule. Avoid "you lost your streak" framing.
- Cap the frequency, and let players choose which notifications they get.

### Gaps
- I found no independent, game-specific study quantifying lift from push notifications or comeback rewards. The Localytics original was not verified.
- I found no data on the effect of iOS/Android notification permission prompts on games, or on when to ask for permission (common advice is after the first loop; unverified here).
