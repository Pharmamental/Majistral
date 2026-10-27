# Educational / Serious Game Design and the Learning Science Behind It (focus: health professions, procedural skills, pharmacy compounding)

Context for the report writer: the target product is a mobile game teaching pharmacy students ointment/cream compounding (choose tools, follow fixed steps, water-bath temperature control 70–75 °C, 1–3 quality stars; errors lower quality but there is no punishment). Research window: searches run 2026-10-27. Effect sizes are Hedges' g or Cohen's d as reported by the source.

## 1. What does meta-analytic evidence say about game-based learning effectiveness, and which design features drive the effects?

### Takeaway
Games beat conventional instruction by a small-to-moderate margin (d/g ≈ 0.3), and the "value-added" research shows that *design choices inside the game* (instructional support, feedback, multiple sessions, debriefing alongside other instruction) matter as much as the medium itself. Motivation gains are weaker and less robust than commonly claimed; in health professions the evidence is mostly low quality.

### Cited Findings
- **Clark, Tanner-Smith & Killingsworth (2016), Review of Educational Research 86(1):79–122.** Studies 2000–2012. Game vs. non-game ("media comparison"): g = 0.33, 95% CI [0.19, 0.48], k = 57 comparisons. Augmented game vs. standard version of the same game ("value-added comparison"): g = 0.34, 95% CI [0.17, 0.51], k = 20. Effects varied with game mechanics, visual/narrative features and study quality; authors conclude design matters beyond medium. — [SRI brief](https://www.sri.com/publication/education-learning-pubs/digital-learning-pubs/digital-games-design-and-learning-a-systematic-review-and-meta-analysis-brief/); [OpenDevEd record](https://docs.opendeved.net/lib/YHX5ZVR8)
  - Note: one secondary source says the review covered 69 quantitative studies; the abstract counts comparisons, not studies. — [Joan Ganz Cooney Center](https://joanganzcooneycenter.org/?p=16779)
- **Wouters, van Nimwegen, van Oostendorp & van der Spek (2013), J Educ Psychol 105(2):249–265.** 77 studies, N = 5,547. Serious games > conventional instruction for learning (d = 0.29) and retention (d = 0.36). Motivation: 31 studies, N = 2,216, d = 0.26 — games were *not* reliably more motivating (abstract wording on significance is inconsistent across copies). Moderators that increased learning: game supplemented with other instruction, **multiple training sessions**, and playing in groups. — [Utrecht research portal](https://research-portal.uu.nl/en/publications/a-meta-analysis-of-the-cognitive-and-motivational-effects-of-seri/); [e-teaching.org summary](https://www.e-teaching.org/materialien/literatur/wouters-van-nimwegen-van-ooostendorp-van-der-spek-2013)
- **Wouters & van Oostendorp (2013), Computers & Education** (meta-analysis of *instructional support* in game-based learning). Support had its largest effect on cognitive knowledge and skills and when it helped learners select relevant information; **reflection, modeling, collaboration, modality, feedback and personalization** had positive effects; "advice" was not significant. Feedback is singled out as among the strongest supports. Supports are especially beneficial for novices. (Exact overall d not verified in this session — check the article.) — [UvA PDF](https://pure.uva.nl/ws/files/13608021/05.pdf); [TUM Clearinghouse summary](https://www.clearinghouse.edu.tum.de/wp-content/uploads/2018/12/CHU_KR-2_Wouters1_2013_Spielbasiertes-Lernen.pdf); [ATD summary](https://www.td.org/insights/three-research-based-guidelines-for-implementing-games-into-instruction)
- **Sailer & Homner (2020), Educ Psychol Rev 32:77–112 (gamification, not full games).** Cognitive outcomes g = 0.49 (k = 19, N = 1,686); motivational g = 0.36 (k = 16, N = 2,246); behavioral g = 0.25 (k = 9, N = 951). Only the cognitive effect stayed stable when restricted to high-rigor studies. **Game fiction (narrative) and social interaction** were significant moderators of behavioral outcomes. — [Augsburg OPUS](https://opus.bibliothek.uni-augsburg.de/opus4/frontdoor/index/index/docId/109056); [Springer](https://link.springer.com/article/10.1007/S10648-019-09498-W)
- **Mayer (2016), "What should be the role of computer games in education?" (Policy Insights from the Behavioral and Brain Sciences).** Five game features that substantially improved learning in value-added experiments: conversational (not formal) wording, spoken rather than printed text, prompts to explain key points (self-explanation), advice/explanations at key points, and pre-game activities describing key components (pre-training). No support for broad transfer of game play to general cognitive skills. — [SAGE press release](https://visus-uk.sagepub.com/en-us/mst/press/what-should-be-the-role-of-computer-games-in-education); [ScienceDaily](https://www.sciencedaily.com/releases/2016/01/160112091354.htm)
- **Health professions — Gentry et al. (2019), JMIR 21(3):e12994.** Systematic review (no meta-analysis due to heterogeneity): 27 RCTs + 3 cluster RCTs, 3,634 participants, 1990–Aug 2017. Knowledge vs. traditional learning: 7 studies, 769 participants, 4 favored games (moderate–large effects), rest null. Skills vs. traditional: 14 studies, 1,195 participants, 6 favored games, rest mixed/null. Vs. other digital education: mostly no difference. Satisfaction higher with games. 25/30 studies at high risk of bias; ~half had < 50 participants; GRADE mostly low/very low. Only one comparison (a **spaced-education game**) reached moderate-quality evidence. Conclusion: games "at least as effective as" controls. — [PMC6458534](https://pmc.ncbi.nlm.nih.gov/articles/PMC6458534/)
- Gorbanev et al. (2018), Med Educ Online, "A systematic review of serious games in medical education: quality of evidence and pedagogical strategy" exists (doi 10.1080/10872981.2018.1438718) but its findings were not retrieved. — [Javeriana record](https://kujane.minciencias.gov.co/Record/JAVERIANA2_d44561a5906e5a1cf975503b2efe7d6e)

### Inferences
- The design lever with best support is **instructional support inside play**, especially explanatory feedback at the moment of error, short reflection/self-explanation prompts, and pre-training on components. For the compounding game this argues for: a short "why" explanation when a wrong tool is picked (e.g., salicylic acid reacts with steel spatula), and a brief post-delivery reflection screen tied to the star result.
- Multiple sessions beat a single session (Wouters 2013) — a real-time, return-later game loop (jobs finishing in real time) naturally produces distributed sessions, which fits the evidence.
- Competition/leaderboards are not shown to be a primary driver; narrative and social interaction moderate behavioral outcomes in gamification. Narrative effects in full games are mixed (Clark 2016 reported variation by narrative features, not a uniform benefit).
- Do not sell the game on "motivation" alone; the robust effect is cognitive, and it is modest (~0.3).

### Gaps
- Clark 2016's specific moderator directions (e.g., whether narrative helped or hurt, whether simple vs. sophisticated visuals mattered, single- vs. multiplayer) were not extracted in this session; the full article should be checked. My recollection (unverified here) is that simpler game-mechanic designs and multiple sessions did better, and that extra narrative did not clearly help.
- Adaptivity as a moderator: no meta-analytic figure retrieved.
- Exact overall effect size of Wouters & van Oostendorp (2013) instructional support not verified.

## 2. Frameworks: intrinsic integration, stealth assessment, MDA, LM-GM, cognitive load, retrieval/spacing, worked examples, scaffolding/fading

### Takeaway
The strongest empirical design framework is **intrinsic integration** (learning content delivered through the core mechanic, Habgood & Ainsworth 2011), backed by a controlled study. **Stealth assessment / ECD** (Shute) is the reference model for measuring competence from gameplay. LM-GM and MDA are descriptive design/analysis tools without strong outcome evidence. **Spacing** has unusually robust health-profession RCT evidence via Kerfoot's spaced-education games.

### Cited Findings
- **Intrinsic integration — Habgood & Ainsworth (2011), J Learning Sciences 20(2):169–206.** Maths game *Zombie Division* (ages 7–11). Study 1: N = 58 children, intrinsic vs. extrinsic (quiz-between-levels) vs. control; children learned more from the intrinsic version under fixed time. Study 2: N = 16 children free to choose; they spent ~**7× longer** on the intrinsic version. Intrinsic = the learning content is delivered through the game's core mechanic and the "flow" of play. — [SHU repository](https://shura.shu.ac.uk/3556/); [Nottingham repository](https://nottingham-repository.worktribe.com/output/23577510)
- **Stealth assessment (Shute).** Assessment embedded invisibly in play, built on **Evidence-Centered Design**: competency model (what you want to know), evidence model (which in-game observables, statistically linked, e.g., Bayesian networks), task model (which activities elicit evidence). In *Physics Playground*, three assessments (physics understanding, creativity, persistence) run concurrently; competency estimates update after every level and an adaptive algorithm picks the next level and supports. Validity is shown by correlating stealth estimates with external tests of the same competency. Shute & Rahimi argue that without ECD stealth assessment reduces to "opportunistic data mining". — [Shute & Rahimi ETRD 2023 PDF](https://myweb.fsu.edu/vshute/pdf/ETRD2023.pdf); [Kim, Almond & Shute IJT 2016](https://myweb.fsu.edu/vshute/pdf/IJT.pdf); [Shute & Rahimi preprint](https://myweb.fsu.edu/vshute/pdf/saecdpreprint.pdf)
- **LM-GM (Learning Mechanics–Game Mechanics) — Arnab et al. (2015), BJET 46(2):391–411.** Model with predefined lists of learning mechanics and game mechanics (drawn from learning theories and game studies); analysts draw a map linking each game mechanic to the learning mechanic it serves. Descriptive, not prescriptive. Trial with 36 participants in 4 countries judged it more rigorous than the Game Object Model. First proposed by Lim et al. 2013. — [Tilburg record](https://research.tilburguniversity.edu/en/publications/mapping-learning-and-game-mechanics-for-serious-games-analysis/); [REF 2021 impact](https://results2021.ref.ac.uk/outputs/a5f53eb9-6cff-40d9-918f-2a32949fedec?page=1); [arXiv 1805.08053 (LM-GM + SDT)](https://arxiv.org/pdf/1805.08053)
- **Spacing / retrieval in a game format — Kerfoot.** 2012 Annals of Surgery RCT: an online game built by adding game mechanics (competition, scoring) to spaced-education (spaced, repeated retrieval questions with feedback) improved guideline knowledge in practicing urologists worldwide over 34 weeks. 2010 J Am Coll Surg: 724 urology residents, spaced education vs. web modules — module learners' gains faded to baseline, spaced-education gains retained over 29 weeks. 2009 J Urol: 2-year follow-up (206 of 537 residents) 70.2% vs 66.8%, effect size 0.35, p = 0.03. Gentry 2019 rated the spaced-education game as the only moderate-quality evidence in health-professions gaming. — [PubMed 22664558](https://pubmed.ncbi.nlm.nih.gov/22664558/); [PubMed 20800189](https://pubmed.ncbi.nlm.nih.gov/20800189/); [Kerfoot 2009 PDF](https://www.gwern.net/docs/spaced-repetition/2009-kerfoot.pdf); [Gentry 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6458534/) (vendor Qstream summaries exist but are not used as evidence)
- **Cognitive load / multimedia principles in games:** Mayer's value-added game experiments found benefits for modality (spoken vs printed text), pre-training, self-explanation prompts and personalization (conversational style) — these are the cognitive-load-theory principles applied to games. — [SAGE press release](https://visus-uk.sagepub.com/en-us/mst/press/what-should-be-the-role-of-computer-games-in-education)
- Instructional support (modeling ≈ worked examples, reflection, feedback) helps novices most in games. — [UvA PDF, Wouters & van Oostendorp](https://pure.uva.nl/ws/files/13608021/05.pdf)

### Inferences
- MDA (Hunicke, LeBlanc & Zubek 2004: Mechanics → Dynamics → Aesthetics; designers work from mechanics, players experience aesthetics) is a widely used vocabulary but not a learning framework; no learning-outcome evidence was sought or found. (Background knowledge; no source retrieved this session.)
- For a procedural skill like compounding, worked-example → faded scaffolding maps onto: first recipe shows the tool choices with reasons (modeling), later recipes remove hints, final recipes rely on the student. Supported in principle by the novice-benefit finding for modeling/support; no game-specific fading study was retrieved.
- Spacing is the most "free" evidence-backed lever for this game: real-time job durations and daily return already create spaced sessions. Retrieval could be built in by re-presenting a previously met tool/incompatibility decision in a new recipe days later rather than as a quiz.
- LM-GM is useful as a design audit: map each mechanic (tool choice, temperature control, stars, rush) to the learning mechanic it serves; any mechanic with no learning mechanic (e.g., rush) should at least not undercut learning.

### Gaps
- No primary, retrieved source for MDA, cognitive load theory (Sweller), worked-example effect, or the chocolate-covered broccoli term in this session; report writer should cite these as background or verify.
- No meta-analytic evidence found specifically on scaffolding/fading inside games.

## 3. Integrating learning into the core mechanic rather than quizzes ("chocolate-covered broccoli")

### Takeaway
The controlled evidence (Habgood & Ainsworth 2011) favors making the learning content *the thing the player manipulates* and the feedback a natural consequence in the game world; quiz-gates between levels (extrinsic integration) yielded less learning and far less voluntary play time.

### Cited Findings
- In Zombie Division, the extrinsic version put the same maths into quiz-like interruptions; the intrinsic version made division the attack mechanic. Intrinsic gave more learning (N = 58) and ~7× more voluntary play (N = 16). — [SHU repository](https://shura.shu.ac.uk/3556/)
- Stealth assessment explicitly avoids interrupting play to test; evidence is drawn from in-play actions. — [Shute & Rahimi 2023](https://myweb.fsu.edu/vshute/pdf/ETRD2023.pdf)
- LM-GM is designed to make the mapping between each game mechanic and a learning mechanic explicit, i.e., to detect where learning is bolted on. — [Tilburg record](https://research.tilburguniversity.edu/en/publications/mapping-learning-and-game-mechanics-for-serious-games-analysis/)
- Gamification layers (points/badges on top of content) have small effects whose motivational component is not robust to rigorous designs. — [Augsburg OPUS, Sailer & Homner](https://opus.bibliothek.uni-augsburg.de/opus4/frontdoor/index/index/docId/109056)

### Inferences
- For this compounding game, the tool choice and the water-bath temperature control are already intrinsic: the decision *is* the pharmaceutical decision, and the quality star is an in-world consequence. This is the right structure per the evidence.
- The "no punishment, lower quality" model is consistent with intrinsic feedback: the consequence is informational (quality), not a lockout. To convert it into learning, the star result should state *which* decision cost quality and why (feedback was the strongest support in Wouters & van Oostendorp).
- Risk: if fixed step order and recipe-supplied ingredients leave only tool choice and temperature as decisions, the "thinking" content per job is thin; the knowledge that is not in a mechanic (e.g., why levigation, why 70–75 °C) will only be learned if surfaced as feedback/explanation.
- Rewarded-ad/rush acceleration is extrinsic to learning; it is fine as long as it never skips a decision (consistent with the project rule).

### Gaps
- The phrase "chocolate-covered broccoli" is commonly attributed to Amy Bruckman (1999, GDC talk "Can Educational Be Fun?"); not verified this session.

## 4. Existing serious games for pharmacy, compounding, pharmaceutics, lab skills — evaluations

### Takeaway
Pharmacy game literature is mostly small, single-site, perception-survey studies with positive but weak evidence. **No peer-reviewed, outcome-measured game dedicated to ointment/cream (nonsterile semisolid) compounding was found** — the closest are a nonsterile compounding escape room, an immersive nonsterile simulation, and MyDispense used for extemporaneous labs. This is a genuine gap the project could fill.

### Cited Findings
- **Aburahma & Mohamed (2015), AJPE 79(4):Article 59** — review of educational games in pharmacy curricula (Cairo University); reported benefits in engagement, confidence, peer interaction; obstacles: staff workload for development/facilitation; noted lack of evidence for games' role in pharmacy curricula. — [PMC4469025](https://pmc.ncbi.nlm.nih.gov/articles/PMC4469025)
- **Kanaan et al. (2023), Pharmacy Education 23(1)** — systematic review of 22 pharmacy-student studies; all reported positive impact; evaluations mostly post-game surveys and/or quizzes. — [FIP Pharmacy Education](https://pharmacyeducation.fip.org/pharmacyeducation/article/view/2408)
- A systematic review of digital serious games related to patient care in pharmacy education concluded games are potentially effective for knowledge and skills but outcomes vs. traditional teaching were inconsistent; most evaluations were perception surveys. — [ResearchGate](https://www.researchgate.net/publication/348874579_Effect_of_Digital_Serious_Games_Related_to_Patient_Care_in_Pharmacy_Education_A_Systematic_Review)
- **Caldas et al. (2020), Curr Pharm Teach Learn** — immersive nonsterile compounding simulation (third-year elective, 2 weeks, "apocalypse" scenario: extract active from yarrow, formulate a mouthwash); N = 30; knowledge and confidence rose pre→post; all 30 completed the product. — [PubMed 32273069](https://pubmed.ncbi.nlm.nih.gov/32273069/)
- **Caldas et al. (2019)** — nonsterile compounding escape room applying educational gaming principles (cited in a review; evaluation details not retrieved). — [PMC9255713](https://pmc.ncbi.nlm.nih.gov/articles/PMC9255713/)
- **MyDispense in extemporaneous formulation labs (Monash)** — virtual pharmacy simulator used as pre-lab for solutions, suspensions, creams and ointments; findings descriptive (students arrived prepared, facilitator discussion shifted to formulation principles), no measured learning outcome. — [PMC9407736](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9407736/)
- **GIMMICS (Groningen)** — simulation game of community pharmacy practice for competency-based education; simulated pharmacies outsource magistral preparations; student evaluations positive. — [PMC7712308](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7712308/)
- **DOSE (Kayyali et al. 2021, Kingston)** — BNF-learning game for pharmacy and nursing students; validated for playability/functionality; attitudes rose after play. — [PubMed 34294266](https://pubmed.ncbi.nlm.nih.gov/34294266/)
- **DIcipher escape room (Nguyen 2020, JACCP)** — drug-information skills; post 76.4 vs pre 68.1, p < .05. — [Wiley JACCP](https://accpjournals.onlinelibrary.wiley.com/doi/10.1002/jac5.1180)
- **Therapeutic decision-making game** — questionnaire, 235 Y2/Y4 students; themes: autonomy, difficulty committing to decisions, fun. — [PubMed 32867933](https://pubmed.ncbi.nlm.nih.gov/32867933/)
- **Dudzinski et al. (2013)** multiplayer game, ~60 students over one week; perceived as interesting and motivating. — [ResearchGate](https://www.researchgate.net/publication/289212575_The_design_and_evaluation_of_a_multiplayer_serious_game_for_pharmacy_students)
- Student preferences for gaming aspects in a pharmacy-practice serious game (cross-sectional). — [PMC5041348](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5041348/)
- Sterile compounding: VR 360 video introduction (Contaifer et al. 2024) and a cross-sectional study where 91.0% (n = 71) wanted wider VR/simulation use in sterile manufacturing teaching. — [doi 10.1177/87551225231220214](https://doi.org/10.1177/87551225231220214); [PubMed 42167095](https://pubmed.ncbi.nlm.nih.gov/42167095/)
- Toronto (2025) virtual immersive simulations for pharmacy and technician students, including a nonsterile compounding case; beta testers enjoyed it (no outcome data). — [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1877129725002291)
- A practitioner blog argues games designed for medicine/nursing omit pharmacy-specific content such as extemporaneous compounding, and discusses limits of virtual compounding ("hands off"). — [CPTL Pulses](https://cptlpulses.com/2021/05/06/virtual-compounding/)

### Inferences
- The novelty claim "a game for semisolid compounding with measured outcomes" is defensible on current evidence, but should be phrased "we found no published…" rather than "none exist".
- The game is best positioned as **pre-lab preparation** (like MyDispense at Monash): students learn tool choices, steps, and temperature ranges before bench work, then the bench lab tests transfer.

### Gaps
- Evaluation results of the Caldas 2019 escape room not retrieved.
- No study found of a mobile (phone) compounding game specifically; Turkish-language pharmacy game literature not searched.

## 5. Measuring learning outcomes in a game for a student population

### Takeaway
Credible evaluation needs more than satisfaction surveys: a validated knowledge pre/post test, ideally a comparison group (e.g., standard pre-lab reading vs. game), a delayed retention test, and a transfer measure in the real lab; in-game analytics should be designed upfront with ECD (competency → observable → task) rather than mined after the fact.

### Cited Findings
- Pharmacy game evaluations rely mostly on post-game surveys/quizzes — the main weakness flagged by reviewers. — [Kanaan 2023](https://pharmacyeducation.fip.org/pharmacyeducation/article/view/2408); [Aburahma & Mohamed 2015](https://pmc.ncbi.nlm.nih.gov/articles/PMC4469025)
- Health-professions gaming RCTs: most at high risk of bias, ~half with < 50 participants, cluster RCTs not analyzed for clustering; authors call for adequately powered, theory-driven RCTs with validated outcome tools, and behavior/patient outcomes. — [Gentry 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6458534/)
- Delayed retention matters: web-module gains faded to baseline within weeks while spaced-education gains persisted 29 weeks and ~2 years (d ≈ 0.35). — [PubMed 20800189](https://pubmed.ncbi.nlm.nih.gov/20800189/); [Kerfoot 2009](https://www.gwern.net/docs/spaced-repetition/2009-kerfoot.pdf)
- Meta-analyses show retention effects (d = 0.36) and the value-added design (game A vs. game A + feature) as the informative comparison. — [Wouters 2013](https://research-portal.uu.nl/en/publications/a-meta-analysis-of-the-cognitive-and-motivational-effects-of-seri/); [SRI brief, Clark 2016](https://www.sri.com/publication/education-learning-pubs/digital-learning-pubs/digital-games-design-and-learning-a-systematic-review-and-meta-analysis-brief/)
- Stealth assessment validity is established by correlating in-game competency estimates with external tests of the same competency; reliability via factor analysis/correlations. — [Kim, Almond & Shute 2016](https://myweb.fsu.edu/vshute/pdf/IJT.pdf); [Shute & Rahimi 2023](https://myweb.fsu.edu/vshute/pdf/ETRD2023.pdf)
- Caldas 2020 used pre/post knowledge and confidence with N = 30 — typical scale for a single pharmacy cohort. — [PubMed 32273069](https://pubmed.ncbi.nlm.nih.gov/32273069/)
- Nguyen 2020 used pre/post challenge scores (68.1 → 76.4). — [Wiley JACCP](https://accpjournals.onlinelibrary.wiley.com/doi/10.1002/jac5.1180)

### Inferences
- Practical design for this game (single faculty cohort):
  1. **Competency model** (ECD): correct tool selection for incompatibilities, correct step logic, temperature control within 70–75 °C, ingredient-function knowledge.
  2. **Evidence model / in-game logs:** per job — each tool choice (right/wrong, which rule), temperature trace (time in range, overshoot), stars, time-to-first-correct on repeat encounters of the same rule (a retrieval/spacing signal), use of the "Reçete" info panel.
  3. **External measures:** short validated MCQ/case test pre, immediately post, and delayed (≥ 4 weeks); a bench-lab OSCE-style checklist for the real ointment/cream prep (transfer).
  4. **Comparison:** randomize lab sections to game vs. equal-time reading/video pre-lab (media comparison), or game with vs. without explanatory feedback (value-added) — the latter is cheaper and more informative for design.
  5. Correlate in-game competency estimates with the external test to validate the stars as an assessment.
- Note that device-clock reliance and rush (halves quality) will contaminate stars as an assessment metric unless logged separately.

### Gaps
- No validated, published knowledge instrument for nonsterile semisolid compounding was found; one would need to be built and piloted.
- Power/sample-size guidance specific to pharmacy game RCTs not found; with typical class sizes (~30–100) only medium-or-larger effects are detectable.
