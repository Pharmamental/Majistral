# Ethical Mobile Game Monetization, Rewarded Ads, and the 2026 Regulatory/Store Landscape

Context: Turkish educational game for pharmacy students (adults, university age). Single currency, no paid speed-ups, no loot boxes, no interstitials; speed-up only via rewarded ads, which must never skip a thinking step. Research date: 2026-10-27. Budget-limited pass (~15 tool calls); several primary documents read only via summaries — flagged below.

## 1. Rewarded ads best practice: placement, frequency caps, reward value, opt-in, retention/revenue, benchmarks

### Takeaway
Industry consensus: rewarded ads work when strictly opt-in, placed at natural breaks, capped per day (commonly 3–5/day or per-session limits with cooldowns), and kept out of a new user's first minutes. Retention/IAP "uplift" figures are vendor-sponsored, mostly old (2017-era), and correlational; eCPM benchmarks for 2024–2026 disagree widely by source.

### Cited Findings
- Suggested standard cap: 3–5 rewarded videos per day or one per session, plus a 2–5 minute cooldown between ad availability — [AppLixir best practices](https://support.applixir.com/hc/en-us/articles/360056835154-Best-Practices-)
- Avoid ad prompts within the first few minutes of a new user's first session — [AppLixir best practices](https://support.applixir.com/hc/en-us/articles/360056835154-Best-Practices-)
- Daily cap with button locked afterward and a countdown to the next day; caps prevent "farming" unlimited rewards; diminishing rewards for repeat views within an hour suggested — [AppSamurai](https://appsamurai.com/blog/11-ways-rewarded-videos-app-revenue/)
- Opt-in framed as the most important factor; place at natural breaks (level completion, game over) — [AppSamurai](https://appsamurai.com/blog/11-ways-rewarded-videos-app-revenue/); [Venatus, May 2024](https://www.venatus.com/blog/best-practices-for-implementing-rewarded-video-ads)
- Track completion rate, CTR and user feedback — [Venatus, May 2024](https://www.venatus.com/blog/best-practices-for-implementing-rewarded-video-ads)
- Tapjoy (2017, 8 high-DAU apps): users who engage with rewarded ads are 4.5x more likely to make an IAP; IAP spend +326% after ad engagement — [AppDeveloperMagazine](https://appdevelopermagazine.com/mobile-rewarded-ads-help-increase-iap-spends-shows-study/)
- Tapjoy: users engaging with rewarded ads in week 1 show ~4x the 30-day retention of average; users completing 20+ rewarded ads had 76% higher retention and 705% higher in-app spend than those completing ≤5 — [PocketGamer.biz](https://www.pocketgamer.biz/tapjoy-rewarded-ads-report/)
- Netmarble case (AdMob marketing): users who opted into rewarded ads had 3x higher retention — [AdMob success story](https://admob.google.co.in/home/resources/hardcore-gaming-publisher-netmarble-triples-user-retention-with-admob-rewarded-video-ads/)
- Unity analysis of rewarded ads' effect on IAP/retention/engagement (vendor) — [Unity blog](https://unity.com/blog/understanding-the-impact-of-rewarded-ads-on-iap-retention-and-engagement) (not fetched in full)
- Appodeal Q4 2024 (100k+ apps): rewarded video has the highest eCPM globally; US averages $13.75 iOS, $12.01 Android — [Appodeal Q4 2024 report](https://appodeal.com/wp-content/uploads/2025/03/Quarterly_Mobile_eCPM_Report_-_Q4_2024.pdf)
- TopOn H1 2025 (via Prado summary): iOS rewarded video eCPM +18% YoY — [Prado](https://prado.co/post/rewarded-video-holds-the-crown-but-interstitial-ads-are-catching-up); contradicted in direction by a Global Games Forum trend analysis reporting US rewarded eCPMs down 20–40%, iOS worse than Android (article date unclear) — [Global Games Forum](https://globalgamesforum.com/features/how-is-your-ecpm-doing-a-six-month-trend-analysis)
- A 2026 blog notes the same US rewarded placement ranges ~$13–$30 eCPM depending on source — [Playio, 2026](https://blog.playio.co/rewarded-ad-benchmarks-2026)

### Inferences
- Opted-in viewers are self-selected engaged players, so the 3–4x retention claims overstate causal effect; treat as "rewarded ads don't seem to hurt retention" rather than "they boost it".
- Turkey is not a Tier-1 ad market; US eCPMs above are an upper bound. For a niche Turkish student audience, ad revenue per user will likely be much lower — revenue projections should not be built on US figures.
- For this game, the "reward" (halving remaining wait) maps well to the documented best practice: opt-in, daily cap (the game already uses 5 rush slots/day, matching the 3–5/day norm), and never during a thinking/learning step (natural-break placement).

### Gaps
- No independent (non-vendor) 2024–2026 study on rewarded-ad retention effects found.
- No Turkey-specific rewarded eCPM figures found.
- Liftoff/Unity/AppLovin 2025–2026 official benchmark reports were not located in this pass.

## 2. Dark patterns in games: academic taxonomies and EU consumer-authority actions (2024–2026)

### Takeaway
Zagal, Björk & Lewis (FDG 2013) define dark game patterns in temporal, monetary and social categories; newer work adds a psychological category and finds ads and monetary patterns strongly associated with "dark" games. The EU's CPC Network issued seven (soft-law) Key Principles on in-game virtual currencies in March 2025 alongside its first coordinated action (Star Stable); the Digital Fairness Act is still proposed-not-enacted as of the latest sources (proposal expected late 2026).

### Cited Findings
- Zagal, Björk, Lewis, "Dark Patterns in the Design of Games" (FDG 2013): dark patterns are "used intentionally by a game creator to cause negative experiences for players which are against their best interests"; categories temporal (grinding, playing by appointment), monetary (pay to skip, frequent microtransactions), social (social pyramid schemes) — [deceptive.design summary](https://www.deceptive.design/articles/dark-patterns-in-the-design-of-games)
- Critique: the taxonomy lacks empirical/ethical grounding for its chosen appeals — [DiGRA 2020 paper, White Rose](https://eprints.whiterose.ac.uk/156460/1/DiGRA_2020_paper_189.pdf)
- Niknejad et al., "Level Up or Game Over" (MUM '24, Dec 2024): 1,496 mobile games from darkpattern.games, 85,388 user-rated pattern instances; adds a psychological category (variable rewards, endowed value, illusion of control). Ads are classed as a temporal pattern; 52.4% of "dark" games had ads vs 37.3% of "healthy" (χ²=34.6, p<.001); "pay to skip" listed under monetary; 96.8% of dark games F2P vs 53.0% healthy; only 10.76% of games had no reported dark patterns. Data are user ratings, not verified observations — [arXiv 2412.05039](https://arxiv.org/html/2412.05039v1)
- Additional 2025 taxonomy work on monetization dark patterns in top-grossing GaaS games exists — [UVa portal](https://portaldelaciencia.uva.es/documentos/6a209679ddc871d315e73a32) (not read)
- CPC Network Key Principles on in-game virtual currencies, adopted 21 March 2025, led by Dutch ACM and Norwegian Consumer Authority — [European Commission news, June 2025](https://commission.europa.eu/news-and-media/news/european-commission-hosts-stakeholders-talks-application-cpc-networks-key-principles-games-virtual-2025-06-03_pl); [Baker McKenzie](https://connectontech.bakermckenzie.com/european-consumer-protection-network-issues-new-key-principles-on-in-game-virtual-currencies-impact-for-gaming-and-gambling-entities-in-belgium-the-eu-and-beyond/)
- The seven principles: (1) show prices in real money, also alongside in-game currency; (2) no hidden costs — avoid multiple currencies or multiple exchanges; (3) no forced overbuying via bundles mismatched to item prices; (4) clear pre-contractual information; (5) inform on 14-day withdrawal right (lost once currency is used); (6) fair, plain-language terms; (7) respect vulnerabilities, esp. children (parental controls, consumer-friendly defaults) — [Reed Smith, Mar 2025](https://www.reedsmith.com/en/perspectives/2025/03/qas-on-the-eu-consumer-protection-authorities-joint-guidance-paper)
- Scope: currencies bought with real money used to pay for in-game content; principles are soft law but signal how authorities interpret the law — [Baker McKenzie](https://connectontech.bakermckenzie.com/european-consumer-protection-network-issues-new-key-principles-on-in-game-virtual-currencies-impact-for-gaming-and-gambling-entities-in-belgium-the-eu-and-beyond/); industry bodies VGE and EGDF called them "misinterpretations of EU consumer law" — [CMS](https://cms.law/en/gbr/legal-updates/level-up-compliance-video-games-industry-in-the-spotlight-again-for-consumer-law-compliance)
- BEUC + 22 members (17 countries) complaint, 12 Sept 2024, against in-game currency practices naming Activision Blizzard, EA, Epic, Mojang, Roblox, Supercell, Ubisoft — [Cointelegraph](https://cointelegraph.com/news/consumer-watchdogs-want-eu-action-on-in-game-digital-money); [BEUC](https://beuc.eu/press-release/consumer-authorities-take-welcomed-first-steps-against-suspected-unfair-practices)
- CPC coordinated action vs Star Stable (21 Mar 2025): bundles not matching item values, prices shown only in Star Coins judged non-compliant; one month to respond — [BEUC PR 2025](https://beuc.eu/sites/default/files/publications/BEUC-PR-2025-015_unfair_practices_in_video_games.pdf); [GamesMarket](https://www.gamesmarket.global/en/business/case-of-star-stable-online-conflict-ahead-eu-commission-and-cpc-set-sights-on-games-industry-1870db4b2004d7d284e1c833a28c1f38)
- Digital Fairness Act: per Commission Work Programme 2026, legislative proposal planned for Q4 2026; no draft presented as of May 2026 — [Heuking, 8 May 2026](https://www.heuking.de/en/news-events/newsletter-articles/detail/digital-fairness-act-implementation-obligations-companies-need-to-prepare-for.html). Fitness check flagged addictive design and "gambling-like features in video games"; 70% of consultation respondents favoured binding rules on addictive design — [Slaughter and May](https://thelens.slaughterandmay.com/post/102m222/digital-fairness-act-european-commission-publishes-responses-to-consultation); [Goodwin, Nov 2025](https://www.goodwinlaw.com/en/insights/publications/2025/11/alerts-practices-antc-from-dark-patterns-to-fair-play)

### Inferences
- The game's single-currency, no-loot-box, no-paid-skip design already sidesteps CPC principles 2–3 and the monetary dark patterns most cited in research. If paid currency is ever added, show real-money price, avoid bundle/price mismatch, provide withdrawal info.
- "Pay to skip" (Zagal) is a monetary dark pattern; an ad-to-skip-wait is its ad-funded cousin and also a temporal pattern ("playing by appointment"/waits). The ethical defence for this game rests on: waits are not artificially inflated to sell skips, rushing has a visible quality cost, cap of 5/day, and no thinking step is skippable. Documenting this rationale is useful if the DFA lands with addictive-design rules.

### Gaps
- DFA status after May 2026 (whether proposal published by Oct 2026) not confirmed — treat as proposed-not-enacted.
- Outcome of the Star Stable action not found.
- Primary CPC Key Principles PDF not read directly; fine figures quoted by commentators (EUR 800k / 6% turnover in Baker McKenzie) unverified.

## 3. Apple App Store and Google Play policies (ads, rewarded ads, kids/teens, loot boxes, data)

### Takeaway
Both stores explicitly permit rewarded ads: Apple lets apps incentivize actions "such as … watching an ad"; Google exempts user opt-in rewarded ads from its interstitial restrictions. Constraints concern disruptive/deceptive ads, kids audiences (Kids Category bans third-party ads; Families requires self-certified ad SDKs), loot box odds disclosure, and consent for data/tracking.

### Cited Findings
- Apple 3.2.2(x): apps "may otherwise incentivize users to take specific actions within apps (such as by completing a level or watching an ad)", but must not force ratings/reviews/downloads — [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Apple 3.2.2(iii): no artificially inflating ad impressions/clicks; no apps "designed predominantly for the display of ads" — [Apple Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Apple 3.1.1: loot boxes must disclose odds before purchase (rule since Dec 2017); purchased in-game currencies may not expire — [Apple Guidelines](https://developer.apple.com/app-store/review/guidelines/); [Fenwick](https://fenwick.com/insights/publications/apple-now-requires-disclosure-of-loot-box-odds)
- Apple 1.3 Kids Category: no third-party analytics or advertising, limited exceptions (no IDFA/identifiable info; contextual ads with human-reviewed creatives) — [Apple Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Apple 5.1.1(ii): consent required for collecting user/usage data even if anonymous; 5.1.2(i): explicit permission via App Tracking Transparency to track; apps may not require enabling tracking to access functionality "or receive monetary or other compensation" — [Apple Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- Apple 2.3.6: answer age rating questions honestly; some app types must use verified/declared age restriction (1.2.1(a), 4.7.5) — [Apple Guidelines](https://developer.apple.com/app-store/review/guidelines/). A tracker notes guideline changes dated 9 Jun 2026 on kids' age-appropriate experiences — [ConductAtlas](https://conductatlas.com/platform/apple/apple-app-store-review-guidelines/provision/CA-P-018902/loot-box-apps-must-disclose-odds-before-purchase/) (unverified)
- Google Play Ads policy: interstitial restrictions don't apply to "rewarded ads which are explicitly opted-in by users"; unexpected full-screen interstitials (incl. at level start/during gameplay) and interstitials not closable after 15 s are banned; ads must be "easily dismissible without penalty", not mimic app UI, and app must not force ad clicks — [Google Play Ads policy](https://support.google.com/googleplay/android-developer/answer/9857753?hl=en)
- Google Play AAID: check ads-personalization opt-out on each access; don't link to persistent IDs — [Google Play Ads policy](https://support.google.com/googleplay/android-developer/answer/9857753?hl=en)
- Google Play Families: child-directed apps must use only Families self-certified ads SDKs; mixed-audience apps need neutral age screening; ads must suit content rating; developer remains responsible — [Families Self-Certified Ads SDK Policy](https://support.google.com/googleplay/android-developer/answer/12918983)

### Inferences
- An opt-in "watch ad to rush" button is store-compliant on both platforms. Key implementation rules: never show the ad without a tap, never penalize declining, never require ATT/tracking consent to get the reward.
- Declare target audience as adults (18+ university students) in Play Console target-audience and Apple age rating so Families/Kids rules don't apply; if declared audience includes under-13s, Families SDK rules and ad restrictions kick in.

### Gaps
- Apple guidelines' "last updated" date and text past 5.2.5 not read; current 2026 age-assurance changes (incl. new age-rating tiers) not verified.
- Google Play loot box odds policy and 2026 policy changes not checked.

## 4. Privacy: GDPR, ATT, Google Families, COPPA, Turkey KVKK and Turkish ad/game rules

### Takeaway
For an adult Turkish audience, KVKK (amended 2024) and GDPR (if EU users reachable) plus Google's EU consent policy (certified TCF CMP) and Apple ATT are the binding constraints; COPPA matters only if targeting US under-13s (amended rule compliance date 22 April 2026). Turkey's KVKK no longer allows cross-border transfer on explicit consent as the primary basis since Sept 2024 — relevant because ad SDKs send data abroad.

### Cited Findings
- Google EU User Consent Policy: AdMob/AdSense/Ad Manager publishers serving EEA, UK (from 16 Jan 2024) and Switzerland (from 31 Jul 2024) users must use a Google-certified CMP supporting IAB TCF; otherwise only Limited Ads. Certification ≠ legal compliance; UMP SDK provides TCF v2 message; users must be able to withdraw consent — [AdMob Help](https://support.google.com/admob/answer/13554020?hl=en); [AdMob Flutter GDPR guide](https://developers.google.com/admob/flutter/privacy/gdpr); [AdMob Unity guide](https://developers.google.com/admob/unity/privacy/gdpr)
- Apple ATT: explicit permission via ATT APIs required to track; cannot condition rewards on tracking consent — [Apple Guidelines 5.1.2](https://developer.apple.com/app-store/review/guidelines/)
- COPPA amendments: effective 23 June 2025; compliance by 22 April 2026 (some safe-harbor provisions excepted); new written infosec program, written data retention policy, expanded personal information definition — [Federal Register, 22 Apr 2025](https://www.federalregister.gov/documents/2025/04/22/2025-05904/childrens-online-privacy-protection-rule); [White & Case](https://www.whitecase.com/insight-alert/unpacking-ftcs-coppa-amendments-what-you-need-know). FTC policy statement (25 Feb 2026) limits enforcement for data collected solely for age verification — [Davis Polk, 16 Apr 2026](https://www.davispolk.com/index%2Ephp/print/pdf/node/116375)
- KVKK amendment by Law 7499, in force 1 June 2024: cross-border transfers now tiered — adequacy decision, then appropriate safeguards (standard contracts, BCRs), then narrow exceptions; old Art. 9(1) explicit-consent basis ended 1 Sept 2024; Yönetmelik on cross-border transfer published 10 Jul 2024; standard contracts must be notified to the Authority — [Erdem & Erdem 2024 Q2](https://www.erdem-erdem.av.tr/bilgi-bankasi/kisisel-verilerin-korunmasi-bulteni-2024-2-ceyrek); [Cott Group](https://cottgroup.com/tr/blog/kvkk-gdpr/item/standart-sozlesme-bildirim-yukumlulugu-ve-yaptirimlari)
- KVKK public announcement (Jan 2026): bundling marketing/advertising push notifications with operational notifications under a single consent defeats the "freely given" element; separate choices required — [Alomaliye, 14 Jan 2026](https://www.alomaliye.com/2026/01/14/mobil-uygulamalarda-tek-tik-riza-donemi-bitiyor-bildirim-amaclari-ayrilacak/)
- EY: KVKK–GDPR harmonisation expected to complete in Q3 2026 (forecast) — [EY 2025 dijital hukuk](https://www.ey.com/content/dam/ey-unified-site/ey-com/tr-tr/services/law/documents/ey-2025-yilinda-dijital-hukuk-alaninda-yasanan-gelismeler.pdf)
- Ticaret Bakanlığı Reklam Kurulu, 2025: first 5 months 736 files, 661 suspension orders, ~125.3m TL fines; May 2025 meeting targeted interface designs steering consumer decisions ("karanlık ticari tasarım") in apps and subscription flows (pre-selected paid plans, card-required "0 TL" trials) — [Memurlar.net](https://www.memurlar.net/haber/1135969/reklam-kurulu-ndan-125-milyon-lira-ceza-ve-durdurma-karari.html); [Forbes TR](https://www.forbes.com.tr/haberler/reklam-kurulu-ndan-bes-ayda-125-milyon-liralik-ceza); H1 2025: 838 files, 753 non-compliant, >141m TL — [Alomaliye, Jul 2025](https://www.alomaliye.com/2025/07/14/reklam-kurulundan-2025-yili-ilk-alti-ayinda-aldatici-reklamlara-141-milyon-tl-ipc-uyguladi/amp/)

### Inferences
- Ad SDKs (AdMob etc.) transfer device/ad-ID data to servers abroad; under post-2024 KVKK, the developer needs a lawful transfer basis (Google's standard contracts/safeguards) and an aydınlatma metni (privacy notice), not just a consent popup. Legal review advisable.
- Turkish Reklam Kurulu is actively enforcing against dark patterns in apps; the game's no-pressure, no-paid-skip design aligns with that direction.
- Serving non-personalized ads by default for Turkish users minimizes KVKK consent exposure; UMP handles EEA/UK/CH.

### Gaps
- No Turkish rule specific to loot boxes, in-game currencies, or rewarded ads in games was found; BTK rules for games not found. Turkish draft legislation on digital games/children (reported in 2024–2025 press) not verified.
- KVKK Board guidance specific to ad SDKs / advertising IDs not found.
- Primary texts (mevzuat.gov.tr, kvkk.gov.tr) not read directly in this pass.

## 5. Ad SDK considerations (AdMob, UMP, mediation)

### Takeaway
AdMob with the UMP SDK is the default route for consent in regulated regions; mediation adds networks (each a separate data processor needing consent coverage, TCF or Google Additional Consent). For Families/kids audiences only self-certified SDK versions are allowed.

### Cited Findings
- UMP SDK delivers the IAB TCF v2 consent message; non-TCF ad tech vendors can be covered via Google's Additional Consent specification — [AdMob Help](https://support.google.com/admob/answer/13554020?hl=en); [AdMob Flutter GDPR](https://developers.google.com/admob/flutter/privacy/gdpr)
- Without a certified CMP, EEA/UK traffic gets only Limited Ads — [AdMob Unity GDPR](https://developers.google.com/admob/unity/privacy/gdpr)
- Families: only self-certified ad SDK versions in child-directed apps; SDKs must rate creatives (at least Everyone/Mature) — [Google Play Families SDK policy](https://support.google.com/googleplay/android-developer/answer/12918983)
- AdMob has an official Flutter integration with GDPR/UMP docs — [AdMob Flutter GDPR](https://developers.google.com/admob/flutter/privacy/gdpr)

### Inferences
- For a small Turkish educational game, AdMob alone (no mediation initially) keeps the vendor/consent surface small; mediation can be added later when volume justifies it.
- Server-side verification (SSV) of rewarded callbacks fits the project's "server clock" rule, so rush rewards can't be faked client-side.

### Gaps
- AdMob SSV, rewarded ad server-side verification docs, and AppLovin MAX/Unity LevelPlay mediation docs were not fetched in this pass.
- No data on AdMob fill rates in Turkey.
