# Mobile Game Economy and Progression Design (single / minimal currency)

Context for the reader: notes are for a timed, educational pharmacy-compounding game (Majistral) with one currency, no paid speed-ups, no loot boxes; the market sells real lab tools (ointment slab → Unguator → ointment mill) and chemicals. Research done 2026-10-27. Search coverage was uneven: Machinations.io, Game Developer (Kongregate idle-math series), Unity's economy guide and Schreiber's Game Balance Concepts course were reachable; no Deconstructor of Fun teardown and no primary Adams & Dormans text surfaced.

## 1. Standard frameworks: faucets/sinks, currency types, inflation control, cost curves

### Takeaway
The universal model is resources flowing between nodes: faucets/taps add currency, sinks/drains remove it, converters turn one resource into another; inflation = faucets minus sinks over time. The classic incremental-game pattern is exponential costs against linear (or polynomial) income, so the next purchase always takes a little longer unless a multiplier or new content resets the ratio.

### Cited Findings
**Faucets, sinks, converters**
- Taps hand players resources, sinks are where they spend them; designers aim for a "pinch point" where taps supply enough to keep sinks interesting but never a surplus. A surplus reduces interest in sinks — [Machinations: What is game economy inflation (undated)](https://machinations.io/articles/what-is-game-economy-inflation-how-to-foresee-it-and-how-to-overcome-it-in-your-game-design); [Machinations: Game economy design in F2P](https://machinations.io/articles/game-economy-design-free-to-play-games)
- Net accumulation rate = total faucet rate − total sink rate; too many faucets destroy the value of effort, too many sinks push players away — [StraySpark blog, "Why Economies Break Games"](https://www.strayspark.studio/blog/game-economy-balancing-spreadsheets); [metavert.io](https://metavert.io/game-economy-design)
- Sinks should be things players want to spend on, not punishments; crafting (consuming materials to make wanted items) is the common example — [Medium, Şahin, "Designing Game Economies"](https://medium.com/@msahinn21/designing-game-economies-inflation-resource-management-and-balance-fa1e6c894670)
- Faucet types: earned (quests, drops), purchased, transfer (trading), systemic (e.g. interest on stored currency); systemic faucets scale with wealth and accelerate inequality — [metavert.io](https://metavert.io/game-economy-design)
- Typical mobile faucets: level completions, daily login bonuses, quests, achievements, rewarded ads. Sinks: purchases, ad removal, cosmetics, entry fees. Converters: hard→soft exchange, or time→currency via rewarded ads; anchor exchange rates to a fixed unit of time or effort — [Unity, "How to design a game economy…", Daniel Godley, 2026-08-12](https://unity.com/resources/game-economy-design-guide)
- Elements vocabulary (sources/taps, drains, converters "like a vending machine", traders) — [LinkedIn summary of game-economy elements](https://tr.linkedin.com/in/serhangunes) (secondary; Adams & Dormans' *Game Mechanics: Advanced Game Design* is the original source of this vocabulary and of the Machinations diagram language, but I could not reach the book text).

**Inflation and its controls**
- Causes: currency from kills/sales/challenges keeps growing total supply; players find more efficient farming as the game ages; generators can flood the economy (Gaia Online hyperinflation; Asheron's Call and Diablo II players switched to barter items because gold was worthless) — [Machinations inflation article](https://machinations.io/articles/what-is-game-economy-inflation-how-to-foresee-it-and-how-to-overcome-it-in-your-game-design)
- Fixes listed: incremental mechanics (taps and sinks scale together, upgrades cost more as production rises), content rotation (new options = new sinks), very-high-end items as long-term sinks, taxation/fees, seasonal resets (controversial), a premium currency bought with gold — same source.
- Schreiber: in positive-sum economies average wealth and prices rise, newcomers struggle; fixes are reducing positive-sum income (e.g. gold only for first-time quest completion, non-tradable rewards) or money sinks (NPC vendors esp. consumables, repair/upkeep, death loss, limited cosmetic luxuries, wealth tax); track total money and average wealth per player over time — [Schreiber, Game Balance Concepts, "Level 10: Final Boss", 2010-09-08](https://gamebalanceconcepts.wordpress.com/2010/09/08/level-10-final-boss/)
- Schreiber also: limiting a resource raises its perceived value and can set natural game length — same source.
- Health metrics to track: inflation rate, currency velocity (how fast earned currency is spent), sink-to-faucet ratio per period/tier, days-of-currency-on-hand (unspent balance ÷ typical daily earning) — [Unity guide, 2026](https://unity.com/resources/game-economy-design-guide)
- "It's far easier to loosen an economy that's too tight than to tighten one that's already too loose" — [Unity guide, 2026](https://unity.com/resources/game-economy-design-guide)

**Cost curves**
- Standard incremental formula: cost_next = cost_base × rate^owned; production_total = production_base × owned × multipliers. AdVenture Capitalist Lemonade Stand: rate 1.07, base cost ≈4, 1.67/s; milestone multipliers at 25 and 50 owned. Bulk-buy cost = b·r^k(r^n−1)/(r−1); max affordable = floor(log_r(c(r−1)/(b·r^k)+1)) — [Pecorella (Kongregate), "The Math of Idle Games, Part I", Game Developer, 2016-10-13](https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i)
- Exponential cost vs linear production means wait times eventually become prohibitive; multipliers/milestones are what restore pace — same source.
- Generator chains (generators producing generators) give polynomial income (x, x²/2, x³/6…) that approaches but never matches e^x, so exponential costs still win — [Pecorella, Part II, 2016-12-14](https://www.gamedeveloper.com/disciplines/the-math-of-idle-games-part-ii)
- Rates seen in practice: 1.07 (AdVenture Capitalist); 1.15 in a tutorial clicker — [dev.to idle clicker tutorial](https://dev.to/dev48v/an-idle-clicker-has-no-engine-and-no-sprites-its-one-raf-loop-paying-you-production-x-k03); Idle Idol started at 1.1× for both cost and reward and saw cost overtake reward around level 35; "even a 0.01 difference" matters hugely by the 20th upgrade — [Padinha, "Balancing Tips: How We Managed Math on Idle Idol", Game Developer, 2020-07-09](https://gamedeveloper.com/design/balancing-tips-how-we-managed-math-on-idle-idol)
- Curve shapes for difficulty/progression: linear, logarithmic (steep early, flat later — good onboarding), exponential (gentle start, steep end), sawtooth (spike then relief) — [openskillindex summary](https://openskillindex.com/skills/neversight-learn-skills-dev-game-balancing) (secondary, low authority)
- Schreiber's cost-curve method (for card/item balance): benefits − cost ≈ 0 for every item; build it in a spreadsheet with conditional formatting to flag outliers — [Schreiber, Level 10](https://gamebalanceconcepts.wordpress.com/2010/09/08/level-10-final-boss/)

### Inferences
- Arithmetic check (mine): at r=1.07 cost doubles every ~10 purchases (≈29× base at 50); at r=1.15 every ~5 (≈1000× at 50). For a game with a handful of tool tiers rather than hundreds of buildings, raw exponent rates matter less than the absolute price ratio between tiers (e.g. each tool tier costs N days of typical income).
- For Majistral the "pinch point" is the key target: income from selling preparations should make the next real tool feel reachable but not trivially, and chemicals (consumed per prescription) are a natural, non-punitive recurring sink, like Schreiber's "consumables from NPC vendors". Because the game has no punishment and products never spoil, there are deliberately no upkeep/loss sinks; consumables plus tool purchases must carry all sink weight.
- A single-player, non-trading economy removes most inflation drivers (no trading, no market prices); remaining inflation risk is only "late-game coins with nothing to buy" — the classic fix is new content/sinks per chapter.

### Gaps
- Could not access Adams & Dormans' book text or Machinations docs on node types directly; vocabulary is confirmed only via secondary summaries.
- Schreiber's full cost-curve chapter in *Game Balance* (Schreiber & Romero, CRC 2021) not reachable; only the 2010 blog course was — [Routledge listing](https://www.routledge.com/Game-Balance/Schreiber-Romero/p/book/9781498799577).

## 2. Balancing income vs upgrade costs and unlock pacing in production/shop games; time-to-next-upgrade targets

### Takeaway
No source gives an industry-standard "minutes to next upgrade"; the closest concrete number is Unity's "one meaningful reward roughly daily for engaged players, every 2–3 days for casual players", plus an S-curve (fast early, steady later). Pacing is set by modelling player types over 30/60/90 days and then playtesting.

### Cited Findings
- Plot reward thresholds as an S-curve: fast early progress, then a steady rhythm; straight-line progression feels too easy late or too grindy early. Example pacing: one meaningful reward roughly daily for engaged players, every 2–3 days for casual — [Unity guide, 2026-08-12](https://unity.com/resources/game-economy-design-guide)
- Model 2–3 scenarios (casual, engaged, theoretical ceiling) in a spreadsheet over 30/60/90 days; set sink-to-faucet targets per progression tier; save big rewards for milestones (too-generous early rewards is a listed mistake) — same source.
- Progression depends on sinks that grow with the player; in incremental designs, buying the next level of a tap is itself the new sink — [Machinations F2P article](https://machinations.io/articles/game-economy-design-free-to-play-games)
- Idle Miner Tycoon cited as retention-focused: generous free offerings, few difficulty spikes; vs. The Elder Scrolls: Blades early access as monetisation-focused grind. "The quality of an economy is basically defined by its purpose." — [Nick Murray at PGC Digital, PocketGamer.biz, 2020-06-09](https://www.pocketgamer.biz/pgc-digital-nick-murray-on-building-effective-in-game-economies/)
- Tycoon playtest anecdotes: a student tycoon where every upgrade could be maxed in ~3 minutes was judged too fast — [Roblox DevForum / creation.dev thread summaries](https://devforum.roblox.com/t/need-help-figuring-out-progression-scaling-for-my-tycoon-style-game/4005654); Compute Tycoon fixed slow early pacing by changing time scale rather than costs — [itch.io devlog 0.3.1](https://dedotrynot.itch.io/computetycoon/devlog/1107975/031-released)
- The upgrade tree is "where most of your design effort should go" because it sets pacing and longevity; show locked sections from the start to create anticipation — [creation.dev, how to make a tycoon game](https://www.creation.dev/blog/how-to-make-a-tycoon-game)
- Idle Idol: playtesters said progression was slow, but the real cause was that the passive-skill screen was hard to find and poorly explained — check whether a "balance" complaint is actually UX — [Padinha 2020](https://gamedeveloper.com/design/balancing-tips-how-we-managed-math-on-idle-idol)
- Merge Mansion coins serve shop items, daily deals, inventory slots and as task objectives (coins as a quest requirement is itself a sink) — [Metacore support](https://support.metacoregames.com/hc/en/merge-mansion/articles/what-can-i-use-coins-for-82)

### Inferences
- For a timed game where jobs take real minutes/hours, the natural unit for pricing is "prescriptions' worth of profit" or "hours of play": price each tool tier as a target count of completed orders (e.g. first upgrade after a few sessions, later tiers days apart), then derive coin prices. This matches Unity's "anchor to time or effort" advice.
- Since Majistral bans paid speed-ups, the usual F2P lever (frustration → pay) is absent; pacing should be judged only on retention and learning, so the Idle-Miner-style "generous, few spikes" profile fits.
- Real tool upgrades (slab → Unguator → mill) should change what the player can do (throughput, new station, quality) rather than only a number; see section 5.

### Gaps
- No credible published "time-to-next-upgrade" benchmark for production/shop mobile games (Hay Day, Idle Miner, Good Pizza Great Pizza etc.) was found; any minute target should be treated as a hypothesis to playtest.
- No Deconstructor of Fun teardown surfaced in search.

## 3. Single-currency vs dual-currency: tradeoffs and examples

### Takeaway
Dual (soft/hard) currency is the F2P default because the hard currency is the monetisation bridge; single-currency economies are simpler to understand and design but give fewer monetisation and spend-steering levers. For a game with no IAP-for-power and no paid speed-ups, the main argument for a second currency disappears.

### Cited Findings
- Most F2P games use at least a dual-currency system; hard currency is scarce, tied to real money, gates premium content; soft currency prices routine upgrades/boosts — [Unity guide 2026](https://unity.com/resources/game-economy-design-guide)
- Genre table: hypercasual "very limited" economy depth, ~85–95% ad revenue; casual 2+ currencies; RPG/strategy deepest, multiple currencies — same source.
- Single-currency economies are "simple to design and understand, but limit monetization depth", common in casual/hyper-casual — [FoxData glossary](https://foxdata.com/en/glossary/game-economy/) (glossary-level source)
- Nick Murray (consultant): every game should have at least two currencies; single-currency can disadvantage new players in a genre; consider per-system currencies ("sword coins", "shield coins") to steer spending, each with an exchange rate mapped to real money; keep hard currency rare — [PocketGamer.biz, 2020-06-09](https://www.pocketgamer.biz/pgc-digital-nick-murray-on-building-effective-in-game-economies/)
- Mid-core/RPG typically use 3–6 currencies, each tied to a system — [search summary of Unity guide](https://unity.com/resources/game-economy-design-guide) (figure appeared in search snippet; not confirmed in the fetched page text)
- Schreiber prefers selling time rather than advantage, and calls designs relying on paid advantage "lazy" — [Schreiber Level 10, 2010](https://gamebalanceconcepts.wordpress.com/2010/09/08/level-10-final-boss/)
- Rewarded ads as a converter: cap ad-based currency like any other faucet; set ad reward to sample the premium experience without replacing it — [Unity guide 2026](https://unity.com/resources/game-economy-design-guide)

### Inferences
- Murray's multi-currency advice is explicitly monetisation-motivated (exchange rates mapped to real money); it does not transfer to Majistral, whose rules forbid paid speed-ups and random packs. The one benefit worth keeping is spend steering: a single currency can still be steered by gating (tools unlock by chapter/level, not just by price).
- Because rewarded ads in Majistral speed up only time (never skip a thinking step), ads are a time converter, not a currency faucet; keeping them out of the coin economy keeps the single currency clean and avoids the "cap ad currency" problem entirely.

### Gaps
- Could not find a sourced list or postmortem of successful single-currency mobile games (candidates I know of but did not verify in this session: Stardew Valley mobile port, many premium sim/tycoon games). Report writer should not cite examples without a source.

## 4. Tools and methods for economy balancing

### Takeaway
Spreadsheet first (one parameter cell driving all costs, scenario columns per player type), then simulation (Machinations or code, Monte Carlo over personas) judged on distributions not averages, then playtest and live-tune with server-configurable values.

### Cited Findings
- Automate spreadsheets: Idle Idol used one "Cost Increase per Level" cell to update all 40+ upgrades, plus a custom calculator producing per-level values and charts; auto-balanced ~40 passive skills by weighting effect strength, still expecting manual tweaks; skills that balanced on paper felt bland in play — [Padinha 2020](https://gamedeveloper.com/design/balancing-tips-how-we-managed-math-on-idle-idol)
- Schreiber: build cost curves in Excel, use conditional formatting to flag unbalanced items — [Level 10, 2010](https://gamebalanceconcepts.wordpress.com/2010/09/08/level-10-final-boss/)
- Machinations case study: 2-hour session, 1 step = 1 minute, Monte Carlo over 100 simulated players across personas (F2P, Hybrid, Premium); converter nodes turn currency+materials into units; judge balance by outcome distribution not mean; iterate by tweaking drop rates/timers and rerunning — [Machinations, "Balancing F2P Economies: Simulating Player Personas…" (≈Nov 2025, vendor)](https://machinations.io/articles/balancing-f2p-economies-simulating-player-personas-and-progression-curves-with-machinations)
- Machinations is a browser tool with a visual (described as Turing-complete) language for systems and large-scale Monte Carlo simulation — [Silicon Canals funding article](https://siliconcanals.com/machinations-io-raises-3m/); Monte Carlo gives more accurate results than simple probability — [Machinations: What are game simulations](https://machinations.io/articles/what-are-game-simulations-and-why-should-you-care)
- Academic: a lightweight Machinations-inspired framework for modelling and balancing the pace toward an achievement such as crafting an item — [arXiv 2404.18574 (2024)](https://arxiv.org/html/2404.18574v1)
- Spreadsheet simulation pre-launch plus server-configurable prices/rates for post-launch tuning without a client patch — [StraySpark blog](https://www.strayspark.studio/blog/game-economy-balancing-spreadsheets)
- Audit every faucet against a matching sink before shipping; track health metrics after launch — [Unity guide 2026](https://unity.com/resources/game-economy-design-guide)

### Inferences
- For Majistral's scale (one currency, ~30 chemicals, a few tool tiers, one chapter) a spreadsheet or a small Dart/Python simulation that replays "N prescriptions per day per persona" is enough; Machinations adds value mostly when several interacting resources exist.
- Prices and order rewards should live in data (already `lib/data/`), ideally server-side later (the project already plans server time), so tuning doesn't need a release.
- A unit test asserting pacing targets (e.g. "casual persona affords tier-2 tool between day X and Y") fits the project's "tests where numbers drive decisions" rule.

### Gaps
- No public, worked spreadsheet template for a timed crafting/shop game was found.

## 5. Keeping progression meaningful (new mechanics vs number growth)

### Takeaway
Pure number growth decays: exponential costs outrun income and wait times grow until something new (milestone multiplier, new tier, new system) restores pace. Sources consistently pair numeric curves with qualitative unlocks, visible locked goals and milestone rewards.

### Cited Findings
- Exponential cost vs linear production eventually makes waits prohibitive; milestone multipliers at fixed counts (25, 50 owned) are how AdVenture Capitalist re-energises — [Pecorella Part I, 2016](https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i)
- Keep lower tiers relevant: price by number purchased, add per-tier boosts so earlier purchases still matter; interdependent currencies/generators add depth — [Pecorella Part II, 2016](https://www.gamedeveloper.com/disciplines/the-math-of-idle-games-part-ii)
- Idle Idol moved from raw-value growth to a formula based on growth of the exponent (order of magnitude), because linked cost/reward curves still felt wrong; constantly-used skills got shorter cooldowns, late-game-strong skills steeper costs — [Padinha 2020](https://gamedeveloper.com/design/balancing-tips-how-we-managed-math-on-idle-idol)
- Content rotation and new options act as fresh sinks and keep currency meaningful — [Machinations inflation article](https://machinations.io/articles/what-is-game-economy-inflation-how-to-foresee-it-and-how-to-overcome-it-in-your-game-design)
- Show locked content from the start for anticipation — [creation.dev](https://www.creation.dev/blog/how-to-make-a-tycoon-game)
- Save big rewards for milestones; S-curve pacing — [Unity guide 2026](https://unity.com/resources/game-economy-design-guide)
- Pacing alternates intense and calmer periods to keep players in flow — [HypeHype Learn, "What is game flow"](https://learn.hypehype.com/game-design/what-is-game-flow)
- In single-player games players expect to get stronger over time, so strict fairness matters less than in competitive play — [Schreiber Level 10](https://gamebalanceconcepts.wordpress.com/2010/09/08/level-10-final-boss/)

### Inferences
- Majistral already has the "qualitative unlock" ingredient built in: each real tool (slab → Unguator → mill) is a different way of working, not +10%. Each purchase should therefore unlock something visible (faster/parallel station, new formulation, higher quality ceiling) rather than only shortening a timer.
- Because the game is educational, the strongest meaningful progression is new prescriptions/dosage forms and new decisions (tool choice, heating control), with coins as the gate; numeric speedups alone would teach nothing.
- Chapter structure (first release = ointments/creams) is a natural reset of the pacing curve: new chapter = new sinks (new tools, new chemicals) absorbing coins accumulated late in the previous chapter.

### Gaps
- No sourced study measuring retention impact of "new mechanic" vs "number" upgrades was found.
- No source on economy design specifically for educational/serious games surfaced.
