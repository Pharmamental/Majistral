# Mobile game core loop, session design and timer/appointment mechanics

Research date: 2026-10-27. Many core design sources date from 2013–2019; dates are given inline. Newest numeric benchmarks are GameAnalytics' 2024-data report (published Feb 2025).

## 1. Frameworks for core loop, meta loop and session length; typical session numbers

### Takeaway
The working framework since about 2013 (Katkoff/Deconstructor of Fun, Telfer/Mobile Free to Play) is a short, repeatable core loop (seconds to minutes), a meta loop for long-term goals, and sessions kept *short but meaningful*, with depth coming from the metagame rather than forced long sessions. The 2024 benchmarks put the median mobile session at about 5–6 min, about 4 sessions/day and about 22 min playtime/day.

### Cited Findings
- **Core-loop definition (2026):** the core loop is the lowest-level repeated action set; higher loops build on it. Loops can be parent/child, intersecting or parallel. Advice: keep it "short and sweet", subtract rather than add, and tie it to one unifying theme. On mobile, players may leave "within a minute or two" if the main mechanics aren't intuitive. — [GameAnalytics, N. Lovato, updated Sep 2026](https://www.gameanalytics.com/blog/appointment-mechanics-how-to-keep-your-players-in-game) (the URL resolved to the "Core game loops" article)
- **Katkoff mid-core model (Oct 2013):** successful mid-core loops have (a) a dual loop, (b) a controlled, short median session length that follows from it, and (c) a metagame outside the visible loop. Overlong sessions are "the cardinal sin". Short sessions should be enabled and rewarded so players return several times a day and form a habit, and longer play should come from the metagame. — [Game Developer, Katkoff, 2013](https://www.gamedeveloper.com/design/mid-core-success-part-1-core-loops)
- **Clash of Clans session sizes (2013):** about 30-second sessions just to collect resources, and a full session (attack + train) under 5 min. Troop training usually takes under 1 hour. Building times start fast and slow down exponentially with progression, which creates mid- and long-term goals. Counterexample: Heroes of Order & Chaos demanded about 10 min of uninterrupted play. — [Game Developer, Katkoff, 2013](https://www.gamedeveloper.com/design/mid-core-success-part-1-core-loops)
- **Metagame (2013):** the "invisible" part where the player earns and spends nothing but optimizes progress, for example by planning. Katkoff says this is what lures players into longer sessions. — [Game Developer, Katkoff, 2013](https://www.gamedeveloper.com/design/mid-core-success-part-1-core-loops)
- **Hay Day loop (2014):** plant/harvest → produce goods in machines → sell for coins+XP → buy equipment. Level-ups unlock meta features. It passes the "Starbucks test": "No matter if you have 30 seconds or 30 minutes … there is something fun to do." — [Game Developer, P. Koistila, Jun 2014](https://www.gamedeveloper.com/business/game-monetization-design-analysis-of-hay-day); loop wording also in [Udonis](https://www.blog.udonis.co/mobile-marketing/mobile-games/hay-day-monetization)
- **Session deconstruction method:** analyze session design by breaking the game into its "daily action loop", the repetitive actions a player takes to progress each day. — [Mobile Free to Play, King of Thieves deconstruction](https://mobilefreetoplay.com/deconstructing-king-of-thieves/)
- **Benchmarks (2024 data, GameAnalytics):** session length median 5–6 min, top 25% 8–9 min. About 4 sessions/day on average, with midcore highest at 6–7 sessions/day. Android players have more sessions than iOS players. Playtime median is 22 min/day. D1 retention top 25% is 26.5–27.7% (iOS 31–33%, Android 25–27%). D7 median is 3.4–3.9%. 75% of projects have D28 below 3%. — [GameDev Reports summary of GameAnalytics 2025 benchmarks](https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks); [PDF](https://investgame.net/wp-content/uploads/2025/02/2025-GameAnalytics-Mobile-Gaming-Benchmarks.pdf)
- **Genre patterns (qualitative only):** arcade leads D1 but has weak long-term retention. Board, card, puzzle and casino games are strongest on medium/long-term retention. Multiplayer leads only on session length. The Q1 2024 report gave a lower global median session of 4.45 min. — [GameDev Reports, 2025](https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks); [GameDev Reports Q1 2024](https://gamedevreports.substack.com/p/gameanalytics-benchmarks-in-mobile)

### Inferences
- For the pharmacy game, a "collect finished cream + start the next job" check-in should be possible in under 1 minute (Clash-style micro-session), while setup/learning (station + tool choice, interactive heating step) forms the longer 3–6 min session. That matches the 5–6 min median.
- The educational content (reading recipes, ingredient roles) can act as the "metagame": no resource is earned, but the player stays engaged and plans.
- Aiming for about 3–4 check-ins per day is in line with the benchmark average. More than that pushes toward the "rapid" end of the toxicity scale (see section 3).

### Gaps
- Genre-level numeric session and sessions/day values (for example for simulation/tycoon) appear only in GameAnalytics charts that were not machine-readable. I found no independent second source.
- I found no benchmark specific to educational or edu-sim mobile games.
- I could not fetch the Deconstructor of Fun "Behind the Success of Hay Day" post (Jan 2013) itself.

## 2. How timer-based games design wait times: length, scaling, parallel slots, return reasons without punishment

### Takeaway
Timers work best when they are *thematic* ("it makes sense this takes that long"), short early and longer later, and *queued/batched* so one check-in clears many of them. Long 4–12 h timers feel restrictive. Daily cycles pace players more strongly but feel more flexible. Reliable numbers on slot counts and scaling curves are scarce in public sources.

### Cited Findings
- **Hay Day ranges:** crops take about 2 min, while building production plants can take 20+ hours. Diamonds (hard currency) are the only skip. Storage filling up is a second pacing lever. — [Udonis, Hay Day monetization](https://www.blog.udonis.co/mobile-marketing/mobile-games/hay-day-monetization); [Game Developer 2014](https://www.gamedeveloper.com/business/game-monetization-design-analysis-of-hay-day)
- **Scaling:** construction "starts fast but slows exponentially", while repeatable short actions (troop training) stay under 1 h. Two timer tiers therefore serve different goals: the short tier drives return, the long tier creates goals. — [Katkoff 2013](https://www.gamedeveloper.com/design/mid-core-success-part-1-core-loops)
- **Telfer's pacing tips (Sep 2015):** (1) prefer natural daily/weekly/monthly cycles over 4/8/12 h timers, which "can feel very restricting"; "once per day" paces harder but feels more flexible. (2) Show waiting through animation or in-world motion (Hay Day traders leave and come back; armies visibly travel) instead of a bare countdown. (3) Pace through cost or difficulty instead of time (Fallout Shelter). (4) Use randomized progress inside short loops. Timers must fit the theme. Good examples: construction, and Criminal Case "sending evidence to the lab". Bad example: Agent Alice's arbitrary "plan her next move" wait. If no natural timer fits, rethink the design rather than bolting one on. — [Mobile Free to Play, A. Telfer, 2015](https://mobilefreetoplay.com/3-tips-for-better-pacing-in-mobile-games/)
- **Hearthstone pattern:** one daily quest added per day, holding up to 3, so a player can skip days without loss. No countdown is shown. — [Telfer 2015](https://mobilefreetoplay.com/3-tips-for-better-pacing-in-mobile-games/); [Mobile Free to Play, "Eliminating Energy"](https://mobilefreetoplay.com/eliminating-energy/)
- **Timer design axes (Zvi, Sep 2019), benign → toxic:** Steady→Sudden accumulation; Fixed (resets at a set clock time)→Delayed (X h after use, so every delay is punished "forever"); Slow (daily)→Rapid (every few hours, costs sleep); Batched (timers line up)→Disjoint (many check-ins with one thing to do each); Tracked→Lost (unclear completion); Forgiving (progress pauses)→Punishing (lose things); Isolated→Cumulative (streak wipes); Progressive (own pace)→Competitive; Queued (orders given in advance)→Idle (stations sit idle until you act); Explained→Mysterious; Annoying→Limiting; Incidental→Central. — [LessWrong, "Timer Toxicities", 2019](https://www.lesswrong.com/posts/dGzuDr4955x5mNZ53/timer-toxicities)
- **Parallel slots:** I found no authoritative public source on slot-unlock curves. A Cookie Run wiki describes production buildings with a set number of queue slots that can be extended with premium currency (not verified for Hay Day). — [Cookie Run wiki](https://cookierun.wiki/w/Craft_Buildings)
- **Idle/offline progress:** offline earnings are commonly capped. Examples are an 8 h cap (time beyond is discarded, so 48 h away pays the same as 8 h) and a 12 h window. Some games pay a reduced offline rate (50% offered as a testable option). Clicker Heroes simulates from idle DPS only, ignoring active boosts. Sources are developer blogs and docs of varying quality. — [MergeCiv idle progression](https://mergeciv.io/idle-progression); [hostedgg blog](https://hostedgg.com/blog/signaldecay-offline-first-idle-games); [Clicker Heroes blog](https://blog.clickerheroes.com/offline-progression-in-clicker-heroes/embed/)
- **Appointment design variables (GameRefinery via GameAnalytics):** refresh interval (hourly/daily/weekly/monthly); whether rewards are handed out or need tasks; whether there is progression (login calendar); and how much randomness is involved. — reported in search snippet of [GameAnalytics appointment mechanics article](https://www.gameanalytics.com/blog/appointment-mechanics-how-to-keep-your-players-in-game); the full page could not be retrieved (the URL served a different article)

### Inferences
- Majistral already sits mostly on the benign side of each axis. Hazır ürün bozulmaz (Forgiving/Isolated). Adım zamanları baştan planlanır ve görünür (Tracked/Explained). İstasyon kuyruğu sıradaki adımı otomatik başlatır (Queued). It is single-player (Progressive). The riskiest axes are *Disjoint*, because jobs at different stations finish at scattered times, and the *interactive step*, because the job stops and waits for the player, which moves toward Idle and Sudden. One mitigation, inferred from the Batched axis and Crook's batching advice: suggest or align job lengths so several finish together, and send one batched notification.
- A two-tier timing structure fits. Short early jobs (minutes) teach the loop in the first session. Longer jobs (hours) appear later as goals. A pure 4–12 h timer is a known friction point.
- Making the wait thematic (cooling, resting, the cream setting, the label drying) follows Telfer's "makes sense it takes that long" test.

### Gaps
- No primary source with numeric slot counts or exact production-time curves for Hay Day or similar games. Fan wikis were either outdated (about 12 years old) or for other games.
- No controlled study comparing timer lengths against retention.

## 3. Failure modes of timers and documented fixes, and speed-ups without coercion

### Takeaway
The main failure modes are energy walls that stop play, timers that punish absence (decay, streak wipes, "Delayed" resets), many unsynchronized timers, timers with no thematic sense, and paywall-style "free to wait" pacing. Documented fixes: let players keep playing and pace rewards instead of play (Hearthstone), use daily windows, queues and batching, forgive misses, and for speed-ups keep them optional, bounded and clearly priced. Academic work classes "playing by appointment" as a temporal dark pattern.

### Cited Findings
- Energy systems are "crude but efficient" (one feature doing several jobs). They are disliked largely because they rarely fit the game's setting. The easiest fix is to let players keep playing and limit rewards instead of play. For many games, the realistic best is reframing the energy so it is more palatable. — [Mobile Free to Play, "Eliminating Energy"](https://mobilefreetoplay.com/eliminating-energy/) (circa 2015)
- Defender's view: energy stops players from burning through the narrative in 10 hours, but it is "often badly implemented". — [Pocket Gamer, Hogwarts Mystery energy](https://www.pocketgamer.com/harry-potter-hogwarts-mystery/making-the-case-for-harry-potter-hogwarts-mysterys-energy-system/)
- Critics' labels: "Free To Wait" / "Wait to Play"; timeout timers sped up with money. — [TV Tropes, Freemium Timer](https://tvtropes.org/pmwiki/pmwiki.php/Main/FreemiumTimer)
- A critic's claim (opinion): pay-or-wait pressure is ramped up after the player is hooked. — [Game Wisdom, "Rise and Fall of Pay or Wait"](https://game-wisdom.com/?p=18883)
- Speed-up trust failure: one game made "the last ten minutes … free" to speed up, which made every timer feel unreliable and caused constant checking ("Tracked→Lost"). — [Zvi 2019](https://www.lesswrong.com/posts/dGzuDr4955x5mNZ53/timer-toxicities)
- **Dark patterns (academic):** Zagal, Björk & Lewis, FDG 2013, define dark game design patterns as elements "whose purpose can be argued as questionable and perhaps even unethical", grouped into temporal, monetary and social categories. "Playing by appointment" is the temporal pattern that limits *when* a player can engage, for example daily quests. Pokémon GO and Animal Crossing are cited as pushing players toward inconvenient play times. — [Chalmers record](https://research.chalmers.se/en/publication/177148); [arXiv 2506.23017](https://arxiv.org/pdf/2506.23017); [arXiv 2412.05039](https://arxiv.org/html/2412.05039v1). Critique: the taxonomy lacks empirical grounding and does not state its ethical framework — [DiGRA 2020 paper](https://eprints.whiterose.ac.uk/156460/1/DiGRA_2020_paper_189.pdf)
- **Rewarded-ad speed-ups (vendor guidance, not independent research):**
  - "Finish building now" style speed-up of the player's own action is a standard placement. — [AppLovin](https://developers.applovin.com/es/best-practices/tips-for-using-rewarded-videos-more-effectively); [Pangle](https://pangleglobal.com/resource/27805)
  - Show ads at natural pauses and none in the first minutes of a new player's first session. — [AppLixir](https://support.applixir.com/hc/en-us/articles/360056835154-Best-Practices-)
  - Caps vary widely by vendor: AppLixir 3–5 per session with 2–5 min cooldown, and diminishing reward after the first ad; AppLovin 1–2 per day; Pangle 5–8 per 20–50 min of play. — sources above
  - Idle players watch very many: over 11, or 9.7, rewarded videos per idle session, per two differing vendor figures. — [ironSource/is.com](https://is.com/?p=58218)
  - Show a daily-reset countdown to when the reward is available again. — [AppLovin](https://developers.applovin.com/es/best-practices/tips-for-using-rewarded-videos-more-effectively)

### Inferences
- Majistral's existing rules match the documented fixes: no decay, no penalty, products always sell, a daily cap on rush (5/day), and rush never skips the thinking step. Remaining risk areas:
  - Don't make the rush cheaper near the end of a timer (Zvi's "last ten minutes free" trust problem).
  - Keep the rush cap a fixed daily reset rather than "X hours after use" (Fixed vs Delayed).
  - Keep the quality cost of rushing visible before the press.
- The vendor caps (1–2/day to 5–8 per half hour) differ by an order of magnitude. Majistral's 5/day sits at the conservative end, consistent with its "no coercion" goal.
- Since "playing by appointment" is literally the listed dark pattern, the defensible position is that missing an appointment costs nothing: the job just waits finished.

### Gaps
- No peer-reviewed study quantifying churn caused by energy walls or timers specifically.
- No independent (non-vendor) data on rewarded-ad speed-up frequency against retention.
- I did not read the Zagal et al. full text. The definition of "playing by appointment" comes via secondary papers.

## 4. Push notifications for timers: ethical and effective use

### Takeaway
Ask for permission in context, at the moment the first meaningful timer starts, not at first launch. Frame notifications as a feature the player wants ("tell me when it's ready"). Batch simultaneous completions, send at most 1–2 per day, avoid night hours, and stop a notification type the player ignores. Android 13+ and iOS both require explicit permission.

### Cited Findings
- **Contextual opt-in (Jul 2015):** don't ask on first load. Use a pre-permission dialog explaining value, and ask again a few sessions later if declined. For timer games, ask when the player first starts a valuable timer. Average opt-in in 2014 was about 33% (Adweek, via Crook). — [Adrian Crook, "Timers, opt-ins, and chimes"](https://adriancrook.com/?p=4922)
- **Framing examples:** Farmville 2: Country Escape offers "Farm Reports". Cartel Kings starts opt-in when the player taps "set alarm" on daily rewards. Clash of Clans sends "troops are ready". — [Crook 2015](https://adriancrook.com/?p=4922)
- **Batching and throttling:** combine near-simultaneous completions into one message ("Your Town Hall and three other builds are finished"). Stop "resource ready" pushes after 2 unanswered sends, but don't throttle social types. — [Crook 2015](https://adriancrook.com/?p=4922)
- **Frequency and timing:** at most 1–2 per day, fewer for less engaged players. Send near each player's usual play time, avoid overnight, and track opt-outs per notification type. — [Meta/Facebook Games notification best practices](https://developers.facebook.com/documentation/games/retain/notifications/best-practices)
- Choices (narrative game) uses a timer countdown as the first reason for notifications and sends few pushes overall. — [Udonis push examples](https://blog.udonis.co/mobile-marketing/mobile-games/examples-mobile-game-push-notifications)
- Opt-in remains a bottleneck, especially on iOS, mainly from asking too early or without explaining value (Pushwoosh, 170k+ gaming pushes; vendor data). — [Pushwoosh](https://www.pushwoosh.com/blog/game-app-push-notifications/)
- **Dated evidence:** opted-in users retained at nearly 2× the rate of opted-out (Urban Airship 2013, correlational, likely self-selection). — [MediaPost 2013](https://www.mediapost.com/publications/article/216357/push-messaging-almost-doubles-user-retention-rate.html)
- **Platform rules:** Android 13 (API 33+) requires the runtime permission POST_NOTIFICATIONS, declared in the manifest. — [Android Developers](https://developer.android.com/develop/ui/views/notifications/notification-permission). iOS 12+ supports "provisional" authorization (quiet, non-interrupting delivery without a prompt). — [react-native-notify-kit docs](https://docs.page/marcocrupi/react-native-notify-kit/react-native/reference/Enumeration.AuthorizationStatus) (secondary)

### Inferences
- For Majistral the natural opt-in moment is when the first preparation starts ("Krem hazır olunca haber vereyim mi?"). Interactive steps such as the water bath that waits for the player are the most legitimate reason to notify, because the job is actually blocked.
- Local notifications scheduled on-device from the planned step times would cover "ready" messages without a server. Batching applies when several stations finish within minutes.
- iOS provisional authorization could let the game deliver quiet "ready" notices before the student is ever prompted. This is untested here.

### Gaps
- No rigorous, recent, controlled study on timer-notification lift. The figures are vendor or 2013 correlational data.
- No primary Apple doc fetched on provisional authorization in games.

## 5. Server time vs device time (clock cheating)

### Takeaway
The consensus is that the server is the source of truth. Store an absolute end timestamp, validate completion on the server, and use the client countdown only for display. Offline-capable clients can only raise the cost of cheating, by anchoring network time to the monotonic uptime clock and detecting clock-change events. That anchor breaks on reboot.

### Cited Findings
- **Unity Cloud Code pattern:** store an absolute expiry UNIX timestamp, not a remaining duration. On each action, recompute the remaining time against the server clock and return `serverTimestamp` so the client syncs its display. Keep durations in remote config. Missing data defaults to "expired"; decide whether that is the behavior you want. This does not stop modified clients. — [Unity docs, server time anti-cheat](https://docs.unity.com/en-us/cloud-code/scripts/use-cases/server-time-anti-cheat)
- Only the server should decide whether enough time has passed, so device-clock changes don't matter. — [Unreal Engine forum](https://forums.unrealengine.com/t/mobile-get-date-time-from-a-server/442125)
- Client-only storage can still be hacked, but it at least stops average users from simply changing the device clock (LootLocker lives system). Forum reports say even large titles (Candy Crush) could be cheated by moving the clock forward. — [LootLocker](https://lootlocker.com/blog/how-to-create-a-simple-lives-system); [GameSalad forum](https://forums.gamesalad.com/discussion/comment/318218)
- **Client heuristic:** save timestamps and detect a clock that moved backward. Cheaters often reset the clock to the present after gaining an advantage, so "now earlier than a saved timestamp" catches some cases. — [GameSalad forum](https://forums.gamesalad.com/discussion/comment/318218)
- **Monotonic anchor (Flutter-relevant):** anchor trusted network time to Android `SystemClock.elapsedRealtime()` or iOS `ProcessInfo.systemUptime`, which only move forward. Listen for `ACTION_TIME_CHANGED` on Android and `NSSystemClockDidChange` on iOS. Uptime resets on reboot, so an online re-sync is needed after reboot, and offline after reboot falls back to device time. — [pub.dev monotime](https://pub.dev/packages/monotime); [pub.dev secure_ist_time_guard](https://pub.dev/packages/secure_ist_time_guard). Commercial iOS SDKs combine uptime with HTTP time checks. — [ByteHide](https://docs.bytehide.com/platforms/ios/products/monitor/protections/clock-tampering)
- Paid Unity assets claim hybrid server checks plus local estimation (vendor claims, unverified). — [Unity Asset Store](https://marketplace.unity.com/packages/tools/integration/mobile-time-cheat-prevention-132832)

### Inferences
- Majistral currently uses device time (`JobStore.now`). AGENTS.md lists this as an open hole. A low-cost interim step, before a real server exists, is:
  - store absolute end times (already the case through the planned schedule);
  - record the last-seen time and refuse to advance if the clock moves backward;
  - optionally anchor to an HTTP or NTP time plus uptime when online.
  The proper fix stays server-side validation of job completion and rush use.
- In a game with no paid speed-ups and no PvP, clock cheating harms only the cheater's own pacing. The main stakes are the rewarded-ad economy (ad-skips become worthless) and any future leaderboards or economy. This may justify a lighter interim approach.

### Gaps
- No official Apple or Google doc fetched on clock-tamper detection. Implementation notes come from third-party packages.
- No data on how common clock cheating is in single-player timer games.
