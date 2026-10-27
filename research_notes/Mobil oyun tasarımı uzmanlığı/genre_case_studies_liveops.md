# Genre case studies and live ops: crafting / cooking / shop-management / production-sim / cozy-sim on mobile

Context for the reader: findings feed an educational pharmacy compounding game (prescriptions arrive from doctors, player prepares at stations, real-time jobs, no paid speed-ups, rewarded ads only, small team). Notes extract transferable principles, not features to copy. Source dates are given; many of the strongest primary sources are old (2013-2016) and are flagged as such. Research date: 2026-10-27.

## 1. Which titles define the genre on mobile, and what are their core loops, timers, order systems and progression?

### Takeaway
The genre splits into five loop families: (a) farm/production sims with real-time timers and order boards (Hay Day), (b) level-based time-management cooking with customer patience meters (Diner Dash lineage, Cooking Diary/Cooking Fever), (c) single-shop "craft the order correctly" games (Good Pizza, Great Pizza), (d) merge games where an order board drives an energy-gated board (Travel Town, Merge Mansion), and (e) idle tycoons with a visible production chain and choke points (Idle Miner Tycoon). The pharmacy game sits closest to (a) + (c): real-time production at stations, plus correctness of each order.

### Cited Findings
**Hay Day (Supercell, 2012) - production chains + real-time timers**
- Core loop is a chain: chickens yield eggs, eggs sell for coins or combine with other resources into higher-value goods (waffles, cookies); "each step follows from the last." XP from actions drives levels, and each level unlocks new production — [Deconstructor of Fun, "Behind the Success of Hay Day", ~Jan 2013](https://www.deconstructoroffun.com/blog//2013/01/behind-success-of-hay-day.html)
- Four linked reward actions: plant/harvest, collect manufactured goods, sell goods, buy equipment. Production timers bring players back; lock-screen notifications ("Milk is ready to be collected") announce finished goods. Storage caps create a natural pressure point. Author claims "always something to do in a 30-second or 30-minute session" — [Game Developer community blog, Pete Koistila, "Game monetization design: Analysis of Hay Day", June 2014 (analyses an old v1.15)](https://www.gamedeveloper.com/business/game-monetization-design-analysis-of-hay-day)
- Multiple sales channels unlock over time: truck orders, boat orders, town visitors — [Wikipedia: Hay Day](https://en.wikipedia.org/wiki/Hay_Day). Supercell is still iterating the order systems: v1.71.130 tested a redesigned Boat Orders where the player "chooses where your boat sails, picks your challenge" — [APKMirror changelog for Hay Day 1.71.130](https://www.apkmirror.com/?p=14449440)

**Diner Dash (Gamelab/PlayFirst, 2004/2005) - time-management codifier**
- Designers Nicholas Fortugno, Peter Lee, Eric Zimmerman; considered a codifier of the time-management genre; player handles every task from seating to washing dishes — [Wikipedia: Diner Dash](https://en.wikipedia.org/wiki/Diner_Dash); [Wikipedia: Time management game](https://en.wikipedia.org/wiki/Time_management_game)
- Multiple customer groups at once; each group has a mood meter, and if it drains, customers leave angry — [TV Tropes: Diner Dash](https://tvtropes.org/pmwiki/pmwiki.php/VideoGame/DinerDash) (fan wiki; mechanic description only)
- Later F2P reinvention (Diner Dash Rush) covered in a GDC talk by PlayFirst creative director Tom Hall on creative process and monetization — [GDC Vault listing](https://gdcvault.com/play/1019902/Designing-Games-for-Fun-and) (listing only; content not reviewed)

**Cooking Diary (Mytona, launched Aug 6, 2018) - level-based cooking + meta world**
- Publisher claims 31 districts, 184 restaurants, 470+ story episodes, 10,000+ customization items, 61M+ downloads, 950,000+ guilds — [Mytona blog, "7 Years, 7 Reasons for Success", Nov 28, 2025 (publisher PR, unverified)](https://www.mytona.com/blog/7-years-7-reasons-for-success-cooking-diary-celebrates-its-birthday)

**Good Pizza, Great Pizza (TapBlaze, 2014) - single-shop correctness game**
- Customers personalise orders (toppings, cheese, sauce, slice count); some are unclear and the player must interpret; a wrong order means a refund; players can ask customers to clarify — [Wikipedia: Good Pizza, Great Pizza](https://en.wikipedia.org/wiki/Good_Pizza,_Great_Pizza)
- Equipment upgrades ("autobuddy") automate topping placement as a progression layer; shop decoration is central to appeal ("Rate My Shop" community posts) — [Game Developer, Joel Couture, June 5, 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco)

**Travel Town (Magmatic, 2020; acquired by Moon Active 2022) - merge-2 with order board**
- Orders drive the core loop; generators spend energy to create items; whole board fits on one screen; town-building meta has no customisation and exists to unlock generators — [Naavik, Harshal Karvande, Sept 22, 2024](https://naavik.co/digest/why-travel-town-is-dominating-mobile-merge/)
- Some orders pay coins, others pay Toolboxes needed for specific build stages, giving players a reason to prioritise among orders — [PocketGamer.biz teardown](https://www.pocketgamer.biz/deconstructing-magmatic-games-travel-town/); [Gamigion republish](https://www.gamigion.com/travel-town-deconstruction-merge-2-whales/) (both search-snippet level; not fully read)
- Merge Mansion contrasts by using merging to advance a mystery story with characters — [Naavik, 2024](https://naavik.co/digest/why-travel-town-is-dominating-mobile-merge/)

**Idle Miner Tycoon (Kolibri, July 2016) - idle production chain**
- Core loop shown on one screen: Mine, Transport, Sell, Upgrade. Choke points between stages set the pace and later become monetisation hooks. Monetisation is "pay or wait" (currency or ad) — [GameAnalytics, "Making a Hit Idle Game: Eight Lessons from Kolibri Games", updated Feb 26, 2025 (talk ~2019)](https://www.gameanalytics.com/blog/making-a-hit-idle-game-eight-lessons-from-kolibri-games)
- Problem identified: after several prestiges the game "feels the same"; fix was gameplay that stays strategic as it scales plus new visual mines — [Mobile Free To Play, GDC 2019 recap](https://mobilefreetoplay.com/gdc-2019-deconstructing-idle-miner-tycoon/) (snippet level)

**Potion Craft: Alchemist Simulator (niceplay games / tinyBuild, PC Early Access Sept 2021)**
- 100k copies in 3 days, #1 Steam Global Top Sellers for 3 days, 92% positive at launch; demo at Steam Next Fest likely helped (speculative attribution) — [Gamespress release](https://gamespress.com/Potion-Craft-sells-100k-copies-in-the-first-three-days); [TechRaptor](https://Techraptor.net/gaming/news/potion-craft-steam-sales-hit-100k-sales-in-three-days)
- Crafting hook: only a few recipes can be saved, so players keep experimenting with new ingredients — [NME](https://www.nme.com/news/indie-game-potion-craft-chases-new-world-to-be-steams-top-selling-title-3053236)

### Inferences
- Production-chain games (Hay Day, Idle Miner) succeed when the whole chain is legible at once; for the pharmacy game, a single view showing all stations and their queues (already the Laboratuvar design) is the genre-standard answer.
- Time-management games create tension through patience meters and leaving customers; this conflicts with the project's "no punishment, product always sells" rule. The transferable part is concurrency (several orders in flight), not the failure state.
- Good Pizza and Potion Craft show that a "craft-correctly" game can stand on interpretation/experimentation rather than speed; this is the closest analogue to compounding (choosing tools, temperature control) and the best fit for an educational goal.
- Merge games' order board shows a cheap way to add strategy: orders with different reward types make the player choose order priority.

### Gaps
- No primary design write-up found for Cooking Fever (Nordcurrent) or Cooking Diary's level/timer tuning; only publisher PR.
- No primary source on how Hay Day's truck/boat order generation is tuned (frequency, item selection, difficulty). Searches found only wiki/changelog material.
- No mobile-specific potion/alchemy shop title with a teardown was found (Potion Craft data is PC).

## 2. What do public teardowns, postmortems and interviews reveal about why they retained players or failed?

### Takeaway
Recurring retention drivers: very short time to first meaningful action, a readable loop, soft-launch iteration on economy values, updates that deepen the core loop instead of bolting on systems, and customization/self-expression. Recurring failure modes: content gaps where players run out of things to do, sameness after many cycles (idle prestige), energy walls that grow faster than caps (merge), and no reason to socialise.

### Cited Findings
- Hay Day: DAU/MAU of 55% (AppData) at one point; credited to no forced tutorial and letting players discover; soft launch (~2 months, Canada only) used to fix the first-time flow and change "nearly all initial economy values"; soft launch revealed where players ran out of content, and the team filled those gaps; updates reinforced the core loop and added social features "rather than new elements"; team of 5-10, ~6 months concept to soft launch — [Deconstructor of Fun, ~Jan 2013](https://www.deconstructoroffun.com/blog//2013/01/behind-success-of-hay-day.html)
- Hay Day sells "convenience without ever forcing our players to pay"; ads only in the in-game newspaper for hard currency, no banners or interstitials, and ad demand reportedly exceeds supply — same source, 2013
- Hay Day weaknesses (2014 view): unclear reasons to add friends; no global chat/rankings/guilds at the time — [Game Developer, Koistila, 2014](https://www.gamedeveloper.com/business/game-monetization-design-analysis-of-hay-day)
- Hay Day's market share declined slowly from ~2017, but the decline was slow relative to competitor growth, implying core players retain well — [Deconstructor of Fun, Supercell deconstruction, Apr 2020](https://www.deconstructoroffun.com/blog/2020/4/23/deconstruction-of-supercell)
- Kolibri: dead-simple prototype (no 3D, IAP, social, localisation, long-term goals) hit D1 retention 63-81% vs ~40% typical; a different project (Front Yard Wars) was cut at ~60% complete because of waterfall development and months without testing — [GameAnalytics/Kolibri, updated 2025](https://www.gameanalytics.com/blog/making-a-hit-idle-game-eight-lessons-from-kolibri-games)
- Kolibri process: ~8 weeks internal testing with the whole team playing, ~4 weeks external testing watching D1, organic downloads, ratings, feedback; then scale — same source
- Travel Town: players return to a board with ~20-25% empty space so the first merge happens within seconds; single-screen board; ARPDAU ~$0.35 vs Merge Mansion ~$0.21 (Sensor Tower estimates); much of download growth is attributed to Moon Active's UA budget — [Naavik, Sept 2024](https://naavik.co/digest/why-travel-town-is-dominating-mobile-merge/)
- Travel Town player complaints: orders "start taking a ton of energy" while the cap stays at 100; boredom around level 25 — [search summary citing Google Play reviews](https://play.google.com/store/apps/details?id=io.randomco.travel&hl=en_US) (review-level evidence, weak)
- TapBlaze's earlier pizza game My Pizza Shop (2012) struggled with retention even after adding order-taking challenges — [Google Ads publisher story: TapBlaze](https://www.google.com/ads/publisher/stories/tapblaze/) (snippet level)
- Good Pizza: shop customisation and community sharing named central to ongoing appeal; realism praised by real pizza-shop employees — [Game Developer, June 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco)
- Cooking Diary: "unique assistants" feature (Oct 2022) caused a 15% spike in player activity — [Mytona blog, Nov 2025 (publisher PR)](https://www.mytona.com/blog/7-years-7-reasons-for-success-cooking-diary-celebrates-its-birthday)
- Hay Day Pop (spin-off) analysis: lack of story likely hurts retention — [Deconstructor of Fun, May 2020](https://www.deconstructoroffun.com/blog/2020/5/17/hay-day-pop-or-drop)

### Inferences
- For a small team, the Kolibri pattern (tiny prototype, measure D1 with real players, cut fast) is the most directly transferable process lesson; it also matches the project rule of verifying before calling something done.
- Hay Day's soft-launch lesson "find where players run out of things to do" maps directly to a real-time-job game: the dead time between jobs is the main retention risk, and must be filled with something meaningful (e.g. reading the prescription, learning content) rather than with pay-to-skip.
- Realism as a selling point (Good Pizza praised by real workers) suggests that verified pharmaceutical accuracy can itself be a retention and word-of-mouth asset for the target audience of pharmacy students.

### Gaps
- No proper failure postmortem for a mobile cooking/craft sim was found in this pass (Game Developer postmortems exist for other genres; none surfaced here).
- Retention figures for most titles are old (2013-2019) or third-party estimates.

## 3. Order/request systems: how are orders generated, paced and made varied?

### Takeaway
Two proven generation methods: (1) combinatorial assembly from parts (Good Pizza: thousands of strings in four parts yield over a million variants), grounded in real-world menus; (2) board/inventory-aware generation where the order board and item generation are tuned together so the player can always start acting (Travel Town). Variety also comes from multiple order channels unlocked over time (Hay Day truck/boat/visitors), different reward types per order, and ambiguity the player must interpret.

### Cited Findings
- Good Pizza orders are assembled at runtime from "thousands of order strings broken up into four different parts" (toppings, sauces, slice counts, customizations such as double-baking), yielding "more than a million" order types; many are based on real menus (Supreme, Veggie, Meat Lovers) — [Game Developer, June 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco). Wikipedia instead says "thousands of combinations" — [Wikipedia](https://en.wikipedia.org/wiki/Good_Pizza,_Great_Pizza) (figures conflict)
- Good Pizza: some orders are deliberately vague; the player can ask for clarification; wrong orders mean a refund — [Wikipedia](https://en.wikipedia.org/wiki/Good_Pizza,_Great_Pizza)
- Good Pizza adds new ingredients via seasonal/cultural content (figs, avocado, duck); the 2021 summer avocado/gardening event became permanent — [Game Developer, June 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco)
- Travel Town: item generation logic and order board logic "work together" to keep the board playable at session start (exact method not disclosed) — [Naavik, Sept 2024](https://naavik.co/digest/why-travel-town-is-dominating-mobile-merge/)
- Travel Town: different reward types on orders (coins vs Toolboxes) create prioritisation — [PocketGamer.biz](https://www.pocketgamer.biz/deconstructing-magmatic-games-travel-town/) (snippet level)
- Hay Day: separate channels (truck orders, boat orders, visitors) unlocked progressively — [Wikipedia: Hay Day](https://en.wikipedia.org/wiki/Hay_Day); time-boxed variants such as a 4-day Truck Order Event — [APKMirror changelog](https://www.apkmirror.com/?p=14449440) (snippet level)
- Diner Dash pacing: several customer groups simultaneously, each with its own draining mood meter — [TV Tropes](https://tvtropes.org/pmwiki/pmwiki.php/VideoGame/DinerDash)

### Inferences
- For prescriptions: a "parts" generator (base formulation from a verified list + varying quantity/vehicle/patient detail + occasional doctor note to interpret) gives variety without inventing unverified formulas, since only the verified base set enters the pool.
- Doctors as recurring "customers" with preferences could provide the Good Pizza ambiguity/interpretation layer while staying educational (e.g. a doctor who always writes a certain abbreviation).
- Order generation should be aware of the player's unlocked stations and tools (the Travel Town principle), so a fresh session always has at least one prescription the player can start immediately.
- Different reward types per prescription create choice without time pressure, consistent with the no-punishment rule.

### Gaps
- No public numeric tuning (arrival rate, max concurrent orders, difficulty curves) for any of these games was found.

## 4. Live ops for small/indie teams: events, seasonal content, cadence, how much is needed

### Takeaway
Big F2P titles run weekly updates and weekly event schedules, but the documented small-team patterns are: staged rollouts, a few recurring event templates reused with new skins, seasonal ingredient/content drops that can become permanent, and filling content gaps found in data. Vendor advice of a major event every ~14 days is unverified and likely unsustainable for a tiny team.

### Cited Findings
- Kolibri targeted one update per week; 160+ updates since July 2016; additions included event mines, expeditions, skill trees, season pass; event mines "often doubled revenue for a weekend"; staged rollout over four days to 1% then 5%, 20%, 100% — [GameAnalytics/Kolibri, updated 2025](https://www.gameanalytics.com/blog/making-a-hit-idle-game-eight-lessons-from-kolibri-games) (note: by then Kolibri had grown from 4 to 100+ people)
- Cooking Diary publishes a weekly event schedule on social media so players can plan; 16 events became permanent features — [Mytona blog, Nov 2025 (PR)](https://www.mytona.com/blog/7-years-7-reasons-for-success-cooking-diary-celebrates-its-birthday)
- Good Pizza runs holiday and seasonal events (e.g. Halloween 2021) and promoted a successful event mechanic to permanent — [Game Developer, June 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco)
- Hay Day: early live ops focused on filling content gaps and reinforcing the core loop; later short events such as a 4-day Truck Order Event and seasonal cosmetic changes (Valentine pink boat) — [Deconstructor of Fun, 2013](https://www.deconstructoroffun.com/blog//2013/01/behind-success-of-hay-day.html); [APKMirror changelog](https://www.apkmirror.com/?p=14449440)
- Lean metas depend more on live ops for variety (Travel Town) — [Naavik, Sept 2024](https://naavik.co/digest/why-travel-town-is-dominating-mobile-merge/)
- Vendor guidance suggests a major event every ~14 days with daily/weekly touchpoints; other vendors say cadence depends on team size and small studios should start lightweight, build rest weeks in, rotate event types to limit fatigue; one source argues a team able to run one seasonal event cannot sustain a 14-day cycle — [Innovecs Games, 2026](https://www.innovecsgames.com/blog/liveops-strategy-for-games/); [Game Growth Advisor, Mar 2026](https://gamegrowthadvisor.com/blog/2026-03-31-liveops-strategy-mobile-games-guide/) (vendor blogs, low authority, figures unverified)

### Inferences
- A realistic small-team plan: a handful of reusable event templates (e.g. "seasonal ailment week": flu season, summer sunburn creams, winter dry-skin ointments), each needing only new verified formulas plus a cosmetic skin, on a monthly or seasonal cadence rather than weekly.
- Seasonality fits the subject naturally: dermatological demand is seasonal, so events can be both educational and thematic.
- Because every new formula needs two-source verification, content cadence will be bounded by verification throughput, not engineering; plan events around a pre-verified backlog.
- Promoting the best-performing event content to permanent (Good Pizza, Cooking Diary) is a cheap way to grow the base game.

### Gaps
- No primary interview with a truly small (under ~10 people) mobile sim team describing their actual event cadence was found; mobilegamer.biz/PocketGamer.biz interviews on this did not surface.
- Server-side event tooling costs for small teams not covered.

## 5. Indie success stories, premium mobile, and Apple Arcade-style models as alternatives

### Takeaway
Small teams have built genre hits (Hay Day 5-10 people; Kolibri started with 4), but usually via fast prototyping and retention testing. Premium mobile can work with strong platform featuring (Stardew Valley iOS $1M in ~3 weeks in 2018), while Apple Arcade went from generous (2019) to shrinking upfront fees and opaque per-play bonuses (2024 report), favouring long-retention games.

### Cited Findings
- Hay Day: team of 5-10, ~6 months to soft launch, top-10 grossing ~4 months after global launch via slow organic growth — [Deconstructor of Fun, ~2013](https://www.deconstructoroffun.com/blog//2013/01/behind-success-of-hay-day.html)
- Kolibri: began as 4 people in a student apartment; grew to 100+; 100M+ downloads across two idle titles; differentiated with a twist on a known format (mining down instead of building up) — [GameAnalytics, updated 2025](https://www.gameanalytics.com/blog/making-a-hit-idle-game-eight-lessons-from-kolibri-games)
- TapBlaze: founder Anthony Lai, Good Pizza was his third pizza title (iterating on one theme) — [Game Developer, June 2024](https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco); [Google Ads story](https://www.google.com/ads/publisher/stories/tapblaze/)
- Stardew Valley iOS ($8, no IAP) grossed over $1M in about three weeks in Oct-Nov 2018 with prime Apple featuring; analysts called the $8 price a barrier — [Sensor Tower, 2018](https://sensortower.com/blog/stardew-valley-revenue-1-million)
- Apple Arcade (report dated Feb 26, 2024): early (2019-) upfront fees and per-play payments generous, most early games profitable from day one; upfront fees since cut; bonus pool declined since ~Oct 2020 and tied to an opaque "qualifying session" metric; Apple now greenlights few originals without big family-friendly IP; featuring hard to obtain; one developer still "very very happy Arcade exists"; Netflix pays upfront with no ongoing payments — [mobilegamer.biz, Neil Long, Feb 2024](https://mobilegamer.biz/inside-apple-arcade-axed-games-declining-payouts-disillusioned-studios-and-an-uncertain-future/)
- Apple (2026) says more premium games arrived on the App Store in 2026 than 2025 but discloses no sales figures; Arcade has 250+ games from 180 developers — [Mobile Marketing Reads, 2026](https://www.mobilemarketingreads.com/apple-reports-growth-in-premium-ios-games-as-new-app-store-chief-outlines-gaming-strategy/) (secondary)

### Inferences
- The project's ethics rules (one currency, no paid speed-ups, rewarded ads never skip thinking) resemble Hay Day's "sell convenience, never force" stance and are compatible with F2P with rewarded ads; a premium or institutional (university licence) model is a realistic alternative for an educational title but depends on featuring/distribution the team cannot control.
- Apple Arcade is not a reliable plan for a small educational title in 2026: originals without big IP are rarely greenlit (per 2024 report).
- A narrow, accurate niche (pharmacy students) is a "twist on a known format" in the Kolibri sense: familiar production-sim loop, new subject.

### Gaps
- No sales data found for Kairosoft's premium mobile titles or for educational/serious games in this genre.
- No data on institutional/B2B (university) licensing for educational mobile games; separate research needed.
- Apple Arcade terms after Feb 2024 not verified from a primary source.
