# Playtesting, analytics, soft launch and store presence for small-team mobile games (2024-2026)

Context: Flutter mobile game, solo or very small team, niche audience (Turkish pharmacy students). Notes were checked on 2026-10-27. Where only secondary or vendor sources exist, that is marked.

## 1. Playtesting methods: think-aloud, observation, surveys, how many testers, when

### Takeaway
Small, repeated qualitative rounds work better than one big test: about 5-8 players per round, a think-aloud protocol, silent observation, then fix and test again. A standard questionnaire such as GUESS-18 adds a comparable score between builds. For a niche audience, the players should be actual pharmacy students, and fewer of them still go a long way.

### Cited Findings
- Commonly recommended format: 30-60 minute sessions with 5-8 testers using a think-aloud protocol. — [Bugnet: How to run effective playtest sessions](https://bugnet.io/blog/how-to-run-effective-playtest-sessions); [Wayline: Effective playtesting sessions](https://www.wayline.io/blog/effective-playtesting-sessions-indie-game-success) (indie blogs, secondary sources)
- Several small rounds beat one large one; one guide's example is three sessions of six people across different builds. — [Wayline: Effective playtesting strategies](https://www.wayline.io/blog/effective-playtesting-strategies-indie-games) (secondary)
- Think-aloud matters because players often cannot remember afterwards why they did something. Watch silently and do not guide the player. — [Wayline](https://www.wayline.io/blog/effective-playtesting-sessions-indie-game-success); [gtstu: How to playtest your indie game without a team](https://gtstu.com/playtest-indie-game-solo-developer/) (secondary)
- One guide argues that about 10 players are enough to test an alpha core loop. — [Wayline: playtest alpha core loop ten players](https://www.wayline.io/blog/playtest-alpha-core-loop-ten-players) (secondary)
- GUESS (Game User Experience Satisfaction Scale): 55 items covering 9 constructs of video game satisfaction. It was developed through expert review, a pilot, EFA (N=629) and CFA (N=729), and validated on more than 450 game titles. — [ERAU portfolio: Development and validation of GUESS](https://portfolio.erau.edu/en/publications/the-development-and-validation-of-the-game-user-experience-satisf/)
- GUESS-18 is a validated 18-item short form (Keebler, Shelstad, Smith, Chaparro, Phan) built for repeated assessments, where 55 items are too cumbersome. Published in the Journal of Usability Studies 16 (2020), pp. 49-62. — [Google Research: Validation of the GUESS-18](https://research.google/pubs/validation-of-the-guess-18-a-short-version-of-the-game-user-experience-satisfaction-scale-guess/)
- Translating GUESS-18 does not by itself preserve its psychometric properties. A Brazilian Portuguese adaptation re-validated it with 259 secondary-school students. — [JIS / SBC journal](https://journals-sol.sbc.org.br/index.php/jis/article/download/8371/4213/43223)

### Inferences
- For this project, a practical cycle is 5-6 pharmacy students per build, one session each (20-40 min, think-aloud, screen plus hands recorded), a short GUESS-18-style questionnaire at the end, then fix and repeat with new students. A university class gives easy access to repeated rounds.
- A Turkish GUESS-18 score should be read as a relative signal between builds, not as a validated absolute measure, because no Turkish validation was found.
- Content correctness (formulas, tool rules) needs a different test: an expert review by instructors or pharmacists, kept separate from fun and usability testing.
- Timing: paper or clickable prototype for the core loop, an internal build for onboarding and first session, then a closed test (Play's 12 testers for 14 days, see section 5) that doubles as the first multi-day retention playtest.

### Gaps
- I could not open Nielsen Norman Group's "5 users" article (network error), so the 5-user heuristic and its 85% problem-discovery claim are not cited here.
- I did not find a primary source on PENS (Player Experience of Need Satisfaction; Ryan, Rigby & Przybylski). Its licensing and item content are unverified.
- I found no authoritative GUR (Games User Research SIG, Steve Bromley) guidance on recruitment numbers. The 5-8 figure comes from indie blogs.
- No Turkish validation of GUESS or PENS was found.

## 2. Analytics: KPIs, event taxonomy, tools, privacy

### Takeaway
The core KPIs are D1, D7 and D30 retention, tutorial or first-session funnel completion, session length and frequency, and drop-off by step or level. Plan a small, named event taxonomy before integrating, using Firebase/GA4 recommended events (`tutorial_begin`, `level_start`, ...) or GameAnalytics progression and design events. Both tools have Flutter SDKs. Under Turkish law (KVKK, the Turkish data protection law), sending analytics data abroad needs a transfer basis other than plain consent since 1 September 2024.

### Cited Findings
- Benchmarks from the GameAnalytics 2026 report (2025 data, 16,262 games, all with at least 1,000 MAU): median D1 about 22%, top 25% just over 30%, top 10% about 40%. Median D7 just under 4%, top 25% about 6-7%, top 10% about 11-12%. D1 kept trending down after 2024. — [GameDev Reports summary of the GameAnalytics 2026 benchmarks](https://gamedevreports.substack.com/p/gameanalytics-mobile-and-pc-game); [2026 PDF](https://investgame.net/wp-content/uploads/2026/01/2026-01-27-2026-mobile-pc-benchmarks_compressed.pdf)
- The 2025 report (2024 data) gave a median D7 of 3.42-3.94%, below 2023's 4-5%. On iOS, top-quartile D1 is 31-33% against 25-27% on Android. Western markets outperform on D7 and D30. — [GameDev Reports: GameAnalytics 2025 benchmarks](https://gamedevreports.substack.com/p/gameanalytics-mobile-gaming-benchmarks); [2025 PDF](https://investgame.net/wp-content/uploads/2025/02/2025-GameAnalytics-Mobile-Gaming-Benchmarks.pdf)
- A third-party article cites a D7 of about 8% for the same data, which conflicts with GameAnalytics' median. — [AppAgent: Mobile game retention benchmarks](https://appagent.com/?p=61637) (conflicting secondary source)
- The D7/D1 ratio is sometimes used as a quick health indicator. — [GameDev.net: The D7/D1 retention ratio](https://gamedev.net/blogs/entry/2298160-the-d7d1-retention-ratio-for-mobile-games-a-complete-guide) (secondary)
- GA4/Firebase limits for app streams: 500 distinctly named events per app user (automatically collected events excluded), event names up to 40 characters, 25 parameters per event, 25 user properties (names up to 24 characters, values up to 36). — [Google Analytics Help: Collection limits](https://support.google.com/analytics/answer/9267744)
- Firebase logs some events and user properties automatically. Recommended events should be sent with their prescribed parameters to get full report detail. The Flutter plugin has helpers such as `logLevelStart(levelName)`. — [Firebase: Get started with Google Analytics for Flutter](https://firebase.google.com/docs/analytics/flutter/get-started); [FirebaseAnalytics class API](https://pub-web.flutter-io.cn/documentation/firebase_analytics/7.1.1/firebase_analytics/FirebaseAnalytics-class.html)
- GameAnalytics has an official Flutter SDK (`flutter pub add gameanalytics_sdk`). Configure before initialize, then send events. Progression events are manual, use up to three levels (`progression01..03`) with start/complete/fail status, and are meant for funnels, drop-off and completion rates. Design events carry custom IDs. GameAnalytics recommends mapping events before integrating. — [GameAnalytics docs: Flutter SDK](https://docs.gameanalytics.com/integrations/sdk/flutter); [Progression events](https://docs.gameanalytics.com/event-types/progression-events/); [Plan your SDK implementation](https://docs.gameanalytics.com/getting-started/plan-your-sdk-implementation)
- Google Play Data safety: Firebase points to Google Analytics' own data-collection page for disclosure (support.google.com/analytics/answer/11582702). Crashlytics breadcrumbs, In-App Messaging, Remote Config and FCM all use Analytics data, so including them changes what must be disclosed. Firebase encrypts data in transit and transfers it only to subprocessors. — [Firebase: Play data disclosure](https://firebase.google.com/docs/android/play-data-disclosure)
- KVKK: amendments in force since 12 March 2024 (regulation in the Official Gazette, 10 July 2024) replaced explicit consent as the general basis for transfers abroad with a tiered system: adequacy decision, appropriate safeguards (for example standard contracts), and exceptional cases. After 1 September 2024, consent-based transfer is limited to incidental cases. Standard contracts must be notified to the Authority, and a notification module has been live since October 2024. — [EY Türkiye](https://www.ey.com/tr_tr/insights/law/kvkk-degisikliginin-yurt-disi-veri-aktarimina-etkisi); [Alomaliye: KVKK standard contract notification module](https://www.alomaliye.com/2024/10/30/kvkk-standart-sozlesme-bildirim-modulu/); [Cottgroup](https://cottgroup.com/tr/blog/kvkk-gdpr/item/standart-sozlesme-bildirim-yukumlulugu-ve-yaptirimlari)

### Inferences
- Pooled benchmarks are a weak target for a niche educational game. Track your own D1/D7 per build instead, plus learning-specific funnels (first prescription delivered, first heating mini-game done, star distribution).
- A suggested minimal taxonomy, 15-25 events in snake_case under 40 characters: `tutorial_begin`/`tutorial_complete`, `order_open`, `prep_start`, `tool_select` (param: correct or not), `heating_result`, `prep_complete` (stars), `rush_used`, `market_buy`, `session` (automatic). This stays far below the 500-event limit.
- Because the game uses server time later anyway, a self-hosted or EU/Turkey-hosted event log could avoid the KVKK transfer question. If Firebase or GameAnalytics (servers abroad) is used, a lawyer should confirm the transfer basis (standard contract plus notification). This is my assessment, not a sourced conclusion.

### Gaps
- No source specifically covered Firebase or GameAnalytics under KVKK.
- The GA4 recommended-events page did not render, so the exact game-event parameter lists are unverified.
- I did not verify the current `gameanalytics_sdk` version on pub.dev. The docs pin `^1.0.6`, which may be outdated.
- No benchmarks were found for educational or serious games, or for session length.

## 3. Soft launch: what it is, markets, gating metrics, relevance for small or niche games

### Takeaway
A soft launch is a limited-country release to tune retention, monetization and stability before a global launch. It is built around paid user acquisition economics and English-speaking proxy markets, so it fits a Turkey-only niche educational game poorly. For this game, the closed test plus a single-country (Turkey) release with fast iteration plays that role.

### Cited Findings
- Typical soft-launch markets are Canada, Australia, New Zealand, the Philippines and the Nordics: English-speaking, with spending close to US and UK players. Publishers keep the US, UK, Germany and Japan clear during this stage. — [CGMagazine: Why your phone gets new games before everyone else's](https://www.cgmagonline.com/articles/phone-gets-new-games/)
- Canada and Australia have become expensive. Cheaper alternatives include Ireland and the Netherlands, or Israel and the Philippines for cash-strapped teams, though behaviour there is less similar. — [PocketGamer.biz: New soft launch countries](https://www.pocketgamer.biz/new-soft-launch-countries/) (Chartboost-sponsored)
- Typical duration: 3-12 months for big games, 1-3 months for smaller releases. Gating rules of thumb: D1 35-50%+, D7 15-25%+, D30 5-15%+, crash-free 99%+. Games that miss these iterate on onboarding, economy or monetization, or get cancelled. — [MWM glossary: soft launch](https://mwm.ai/glossary/soft-launch) (single vendor glossary; these targets are far above GameAnalytics' pooled medians in section 2)

### Inferences
- The traditional soft-launch logic (proxy markets, then paid user acquisition at scale) does not apply: the audience is Turkish-speaking, there is no user-acquisition budget, and there is no monetization yet.
- A practical equivalent: Play closed test (required) leading to a Turkey-only production release, possibly limited to one or two faculties through word of mouth, with 1-3 months of iteration. Use crash-free rate, tutorial completion and D1/D7 against your own earlier builds as the gate.
- The MWM targets conflict with GameAnalytics' medians (median D7 about 4%). They describe hit-tier commercial games and should not be used as the bar here.

### Gaps
- I found no source on whether small or niche teams skip soft launch, and none on soft launch for educational apps.

## 4. Store presence: ASO, screenshots and video, review prompts, featuring, education category

### Takeaway
Use the platforms' native review APIs only after a meaningful success moment, never behind a "Rate us" button or a pre-question, and offer no incentive. Screenshots should show real gameplay: games on Play need at least three 16:9 or 9:16 images to be eligible for featuring. Apple accepts featuring pitches through App Store Connect Featuring Nominations at least two weeks (ideally up to three months) ahead. Google's form wants three to four weeks.

### Cited Findings
- Google Play In-App Review: trigger only after the user has used the app enough. Ask no question before or during the card, neither "Do you like the app?" nor "Would you rate 5 stars?". There is a time-bound quota (more than one call in under about a month may show nothing), and the quota value is undisclosed. Do not wire a "Rate us" button to the API; send the user to the Play Store instead. Do not modify, overlay or programmatically dismiss the card. — [Android Developers: In-App Review API](https://developer.android.com/guide/playcore/in-app-review)
- Apple: the system shows the review prompt at most three times in 365 days, and calling the API does not guarantee display. Ask at a natural pause after a meaningful accomplishment, not at first launch. Use the system API (`requestReview`/`SKStoreReviewController`). No incentives and no filtering of happy users. — [Apple HIG: Ratings and reviews](https://developer.apple.com/design/human-interface-guidelines/ratings-and-reviews) (the page body did not render in my fetch, so these points rest on Apple's StoreKit guidance as summarized; verify on the live page)
- Apple featuring: submit through Featuring Nominations in App Store Connect, at least two weeks ahead, or up to three months ahead for wider consideration. Editors look at UX, UI design, innovation, uniqueness, accessibility, localization and the product page (screenshots, previews, ratings). For games they add gameplay, art, controls, story, replayability, sound, performance and value. — [Apple: Getting featured](https://developer.apple.com/app-store/getting-featured/)
- Google Play featuring form: submit at least three weeks ahead (four for new launches), with the AAB already in Play Console. It is for new launches, not title updates. Promotional Content and featuring tools for games are tied to programs such as Level Up / Premium Growth tools. — [Google Play featuring review form](https://support.google.com/googleplay/contact/featuring_review?hl=en); [Play Console Help: Promotional content](https://support.google.com/googleplay/android-developer/answer/12932123)
- Apple screenshots: 1 to 10 per device size, JPEG or PNG with no alpha. Required: iPhone 6.5" (1284×2778 or 1242×2688) unless 6.9" (1320×2868 and others) is provided. — [App Store Connect: Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/)
- Google Play games: to be eligible for featuring, at least three 16:9 landscape (min 1920×1080) or 9:16 portrait (min 1080×1920) screenshots showing in-game experience. Two are enough to publish. JPEG or 24-bit PNG, max 8 MB, long side at most twice the short side. Avoid ranking or award claims, testimonials, prices and "play now" calls to action in the images. — [AppRadar (updated July 2026)](https://appradar.com/blog/android-app-screenshot-sizes-and-guidelines-for-google-play); [AppTweak size guidelines](https://apptweak.com/aso-blog/app-screenshot-icon-video-guidelines-ios-gp) (secondary; verify in Play Console help)
- Play promo video: one video, shown before the screenshots. A 15-30 s length is cited, but that source dates from 2020. — [AppFollow](https://appfollow.io/blog/app-store-and-google-play-screenshot-guidelines) (outdated; unverified)
- Google's Play featuring weighs editorial review together with signals such as Android vitals, ratings and update cadence. — [ASOMobile: Featuring 2026](https://asomobile.net/en/blog/app-store-and-google-play-featuring-2026-how-to-get-into-editorial-collections/) (secondary)

### Inferences
- A good review moment here is right after a 3-star delivery or the first finished prescription, through Flutter's `in_app_review` wrapper on both platforms, with app-side throttling (for example at most once a month). Never put it behind a rewarded element.
- Apple's featuring criteria line up with this game's strengths (uniqueness, education, localization). A nomination framed as "the first pharmacy-compounding game for Turkish students", sent about two months before launch, is worth the effort.
- Turkish ASO: put keywords such as "majistral", "eczacılık", "farmasötik teknoloji" and "merhem" in the title, subtitle (Apple) and short description (Play). Competition on these terms is likely near zero.
- Category: Games > Educational (Play) or Games > Education / Simulation (Apple) versus the Education app category. This affects which editors see the app; not verified.

### Gaps
- I did not fetch Apple's app preview specification (length 15-30 s is widely cited but unverified here).
- Not verified: education-category specifics, such as Play's "Teacher Approved" program (aimed at kids, likely irrelevant for university students) and Apple's Education category rules.
- Not researched: AppTweak or Sensor Tower keyword guides.

## 5. Closed testing on Google Play (new personal accounts) and TestFlight

### Takeaway
The rule still stands, checked on Google's official page on 2026-10-27: personal Play developer accounts created after 13 November 2023 must run a closed test with at least 12 testers opted in continuously for at least 14 days before applying for production access. TestFlight allows 100 internal and 10,000 external testers, and external testing needs Beta App Review of the first build.

### Cited Findings
- Play: for personal developer accounts created after 13 November 2023, a closed test needs at least 12 testers opted in continuously for at least 14 days. The days must be consecutive, and a tester who opts out and rejoins resets their count. The page lists no later change. — [Play Console Help: App testing requirements for new personal developer accounts](https://support.google.com/googleplay/android-developer/answer/14151465)
- TestFlight: up to 100 internal testers (team roles) and up to 10,000 external testers by email or public link. Up to 100 builds can be shared, on up to 30 devices per tester. The first external build must pass App Review for TestFlight, and builds added to external groups are submitted automatically. A public link can set device and OS criteria. — [Apple: TestFlight](https://developer.apple.com/testflight/)

### Inferences
- Recruiting 15-20 pharmacy-student testers (a margin above 12 for dropouts) for the 14-day closed test turns a compliance step into the first multi-day retention playtest. Analytics should already be in the closed-test build.
- An organization account (for example a company) is exempt from the 12/14 rule, but needs a D-U-N-S number. This is my understanding; I did not verify it in this session.

### Gaps
- TestFlight build validity (commonly 90 days) is not verified on the fetched page.
- Not verified: whether the 12-tester rule changed in 2025-2026 beyond what the help page says. The page itself showed no change.
