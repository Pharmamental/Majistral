# Art Direction, Visual Identity and Audio Design for Mobile Games

Research date: 2026-10-27. Context: pharmacy compounding game, "old pharmacy" look (porcelain white, cobalt blue, dark walnut counter, Bitter serif, toy-block icons). The sources are mostly practitioner articles and press. Primary sources are marked where they exist.

## 1. Art direction principles for mobile: silhouette, shape language, value/color, consistency, style guides; how distinctive indies established a look

### Takeaway
Readability comes first. Things are told apart by silhouette and shape first, then by value and colour, and fine detail is kept below the main silhouette. A distinctive look comes from a few strict constraints held consistently: a limited palette, one lighting setup, an outline rule and one shape vocabulary. Fidelity matters less. Monument Valley, TF2 and Darkest Dungeon are the usual case studies.

### Cited Findings
- Team Fortress 2 (Valve, 2008): classes are made distinguishable first by colour/value and then by physical silhouette, with art built to "enhance gameplay". This is the canonical readability case study. — [Game Developer, "How Valve Makes Art to Enhance Gameplay" (2008)](https://www.gamedeveloper.com/art/in-depth-how-valve-makes-art-to-enhance-gameplay)
- Too much detail on a moving character becomes visual noise. Small details should support the main silhouette, not distort it. — [80.lv, Character design: shape language and readability](https://80.lv/articles/character-design-shape-language-and-readability/)
- Shape language lets players recognise things fast, especially at distance, in low light or in fast play. Test readability early, at greybox/blockout. — [RocketBrush blog](https://rocketbrush.com/blog/shape-language-in-game-character-design-how-to-make-characters-readable-and-consistent)
- GDC has an Art Direction Bootcamp session on world-building through shape language, which treats culture and story as expressed through physical forms such as architecture. It is members-only and not mobile-specific. — [GDC Vault 1025897](https://gdcvault.com/play/1025897/Art-Direction-Bootcamp-Building-Worlds)
- Monument Valley (ustwo, 2014): the team aimed from the beginning to make "every screen" frameable and wall-hangable. The look barely changed from the first concept art, and the game was always isometric. Influences were Escher, Japanese prints and minimalist 3D. — [PocketGamer.biz, Making of Monument Valley](https://www.pocketgamer.biz/stairway-to-heaven-the-making-of-monument-valley); [Creative Bloq](https://www.creativebloq.com/computer-arts/making-monument-valley-71412213)
- On Monument Valley, Killscreen wrote that minimalist "addition by subtraction" is attractive but "not at all easy to actually do well". — [Killscreen](https://killscreen.com/monument-valley-elegance)
- Monument Valley's art team printed references and level designs and pinned them to foam boards around the office, so the whole team stayed immersed in the style. This works as a physical style guide. — reported via [Android Authority](https://androidauthority.com/monument-valley-inspiration-art-design-902394) (citing a Milanote interview with art director David Fernández Huerta)
- Darkest Dungeon is cited as a small-team identity built from heavy black outlines, a limited palette and distinctive character design. A distinct style can come from a consistent palette, a specific lighting setup or a unique effect, without unique models. — [Wayline blog](https://www.wayline.io/blog/free-asset-trap-generic-game) (practitioner opinion)
- Industry briefs for mobile now ask explicitly for "strong silhouette readability for small mobile screens". — [Freelancer brief](https://www.freelancer.de/projects/2d-game-art/comprehensive-art-direction-for-mobile) (a job post, so a weak signal)

### Inferences
- For this game, the porcelain/cobalt/walnut palette should be checked by value as well as hue. A greyscale screenshot test shows whether cards stay legible on the dark counter and the primary cobalt button stays the one high-contrast focal point.
- The "frameable screen" test from Monument Valley is a cheap acceptance criterion for each screen.
- A one-page style guide should fix the light direction, outline rule, corner rules and palette tokens. A pinned reference board does the same job in practice. The project's AGENTS.md already holds most of this.

### Gaps
- I found no mobile-specific GDC talk on silhouette readability with accessible content, and no source with numeric value-contrast rules for game art (as opposed to UI text).
- No primary source discussed Monument Valley's palette choices in detail.

## 2. Iconography: item icon readability, consistent lighting/outlines, icon sets at scale

### Takeaway
Icon sets live or die on four things: a distinct silhouette per item, minimal internal detail, one shared light direction and outline treatment, and no reliance on colour or text alone. Icons should always be checked at their real display size, side by side.

### Cited Findings
- Eight rules (Game Developer, 2020):
  1. Avoid similar shapes; each icon must be identifiable by silhouette alone.
  2. Minimise complexity, since more elements means less contrast and slower recognition.
  3. Keep one visual style and design icons side by side.
  4. Don't rely on text inside the icon; put a label below it.
  5. Use established metaphors.
  6. Never reuse one icon for different functions, and keep active and inactive states distinct.
  7. Design for small sizes.
  8. Don't rely on colour; shape is the primary cue, which also helps colourblind players.

  — [Game Developer, "Icon design rules you should know" (Iuliana U., 2020-03-10)](https://www.gamedeveloper.com/design/icon-design-rules-you-should-know)
- Use one light direction across the whole HUD (top-left is the common default). Draw outlines in a darker shade of the icon's own colour rather than pure black, which looks harsh when small. Use one rim and one highlight, since heavy shading muddies tiny icons. — [Wayline, Game UI & HUD lessons](https://www.wayline.io/learn/game-ui-art/2), [lesson 4](https://www.wayline.io/learn/game-ui-art/4)
- Oracle's Alta realistic-icon guide specifies top-down light and caps shadow opacity at 25%. It recommends the simplest image that still communicates the object. — [Oracle Alta icon guide](https://www.oracle.com/webfolder/ux/middleware/alta_web_icon_guide/Alta-Style-Production-Guide/Realistic-Icons.html)
- A store icon needs one bold focal idea. An in-game set needs distinct silhouettes within the set. — [Made Good Designs](https://madegooddesigns.com/?p=5494)

### Inferences
- The project already draws look-alike sibling chemicals (Tween/Span, the two parabens) in the same container, separated by lid colour. That breaks rule 8 (colour as the only differentiator) unless the name label is always shown beside the icon. Either keep the label mandatory or add a shape mark (for example a numeral or a lid shape).
- Fixing one light direction and an outline-colour rule in the icon generator (`tools/ikon_blok/uretici.html`) would keep a growing set coherent.

### Gaps
- I found no authoritative large-studio postmortem on scaling icon sets to hundreds of items; the sources are tutorials.

## 3. Avoiding a generic, "AI-made" or asset-store look; 2024-2026 mobile style trends

### Takeaway
Players and reviewers readily spot mixed asset packs and default "AI aesthetics". The answer from practitioners is a cohesive, constrained, specific style rather than higher fidelity. Cozy, tactile and diorama/toy-like looks are visibly popular, but there is no hard market data on mobile style trends.

### Cited Findings
- Using free assets heavily almost guarantees a generic look, because the same packs appear across many games. Reviewers call such games "Generic", "Uninspired", "Looks like every other Unity game". Mixing visually inconsistent packs undermines cohesion. — [Wayline: free asset trap](https://www.wayline.io/blog/free-asset-trap-generic-game); [generic art style doomed our game](https://www.wayline.io/blog/generic-art-style-doomed-our-game) (single-site practitioner blogs; the studies they cite could not be verified)
- Stylised and 2D art lets small teams produce visually strong games, and pixel art has resurged partly because of its low production cost. — [Wayline: indie devs embrace stylized](https://www.wayline.io/blog/indie-devs-ditch-realism-embrace-stylized-animation)
- Cozy games are growing: twice as many cozy games released on Steam in 2024 as in 2023, and nearly as many in the first eight months of 2025 as in all of 2024. This is PC data. — via search summary of [Wikipedia: Cozy game](https://en.wikipedia.org/wiki/Cozy_game) and roundtable coverage (secondary)
- Toy and diorama framing ("props scaled and styled like collectible figurines on a shelf") shows up in 2026 releases such as Mini Worlds Dioramas (PC, April 2026). Common AI-prompt vocabulary for "cozy mobile-game style" includes low-poly, pastel, tiny props and tilt-shift. — [games.gg](https://games.gg/mini-worlds-dioramas/); [carat.im prompt gallery](https://carat.im/id/prompt-gallery/diorama-style)

### Inferences
- The fact that pastel, tilt-shift, low-poly "cozy diorama" is now standard AI-prompt vocabulary suggests it reads as AI-default. That matches the project's decision to drop cream, terracotta and Nunito. Material-derived choices (porcelain, cobalt glaze, walnut grain, apothecary-label serif) are more defensible as "authored".
- Toy-block icons carry a trend risk. They stay distinctive only if they keep the pharmacy-specific objects and the project's own light and outline rules.

### Gaps
- I found no Sensor Tower or data.ai report on mobile art-style trends for 2024-2026, and no quantitative evidence that a "generic" look lowers mobile retention or installs.

## 4. Using AI image generation in game art (2025-2026): store rules, copyright, reception

### Takeaway
Steam requires disclosure of AI content that players see (rules narrowed in January 2026). Apple and Google have no rule requiring disclosure of AI-made art in a game. Their rules target apps that generate content and data sharing with third-party AI. In the US, purely AI-generated output is not copyrightable. Sentiment among both developers and players turned sharply negative in 2025-2026.

### Cited Findings
**Steam (Valve)**
- Steam's Content Survey (since January 2024) splits AI use into "pre-generated" content (made with AI during development) and "live-generated" content (made while the game runs). Pre-generated content falls under the Distribution Agreement promise that there is no illegal or infringing content and that the game matches its marketing. Live-generated content additionally needs a description of guardrails, and players can report it through the overlay. — [Steamworks Content Survey docs (primary)](https://partner.steamgames.com/doc/gettingstarted/contentsurvey); [VGC (2024)](https://www.videogameschronicle.com/news/steam-pages-will-now-disclose-which-games-use-ai-generated-content/)
- In January 2026 Valve rewrote the form. Only AI content players actually consume needs disclosure: in-game content, store-page assets and marketing. Internal efficiency tools such as code assistants are exempt. — [Notebookcheck](https://www.notebookcheck.net/Steam-updates-AI-disclosure-form-requiring-developers-to-report-visible-and-in-game-AI-but-not-background-tools.1206103.0.html); [Gigazine (2026-01-20)](https://gigazine.net/gsc_news/en/20260120-steam-updates-ai-disclosure-guidelines)
- Adoption figures conflict: about one in five listed games versus about 33% of new releases (an August 2026 report). Neither could be verified from a primary source. — [tech-insider](https://tech-insider.org/steam-ai-disclosure-2026); [ainauten](https://news.ainauten.com/markdown/steam-ai-inhalte-werden-bereits-bei-einem-drittel-der-neuerscheinungen-offengelegt)
- In October 2026, Next Fest users asked for a filter to exclude AI games. No such filter is confirmed. — [braindetox.kr](https://braindetox.kr/en/posts/steam_ai_game_exclusion_filter_request.html)

**Google Play**
- The AI-Generated Content policy covers apps that generate content from prompts (text, image, voice). These must prevent restricted content and let users flag offensive output. Apps that only host AI-made content and cannot create it are out of scope. — [Google Play Console Help 14094294 (primary)](https://support.google.com/googleplay/android-developer/answer/14094294)

**Apple App Store**
- In November 2025, guideline 5.1.2(i) began requiring apps to "clearly disclose where personal data will be shared with third parties, including with third-party AI" and to get explicit permission. — [TechCrunch (2025-11-13)](https://techcrunch.com/2025/11/13/apples-new-app-review-guidelines-clamp-down-on-apps-sharing-personal-data-with-third-party-ai)
- A later revision of Guideline 1.2 names AI-made nonconsensual intimate imagery as content apps must prevent and remove. Sources disagree on the date (October 2025 versus October 16, 2026). — [ppc.land](https://ppc.land/apples-app-store-rules-now-require-apps-to-remove-ai-intimate-imagery/)
- I found no Apple rule requiring disclosure that a game's pre-made art was AI-generated.

**Copyright (US)**
- The USCO report Part 2 (2025-01-29) holds that copyright needs human authorship and that prompts alone give insufficient control. Protection can still cover human expression perceptible in the output, creative selection, coordination or arrangement, and creative modification. Each case is analysed individually. — [Copyright Alliance summary](https://copyrightalliance.org/ai-report-part-2-copyrightability/); [Crowell](https://www.crowell.com/en/insights/client-alerts/us-copyright-office-releases-part-2-of-artificial-intelligence-report-clarifying-copyrightability-of-generative-ai-outputs)
- Thaler v. Perlmutter: the D.C. Circuit affirmed the human-authorship requirement (2025-03-18), and the Supreme Court denied certiorari on 2026-03-02 (No. 25-449). — [Baker Donelson](https://www.bakerdonelson.com/supreme-court-denies-certiorari-in-thaler-v-perlmutter-ai-cannot-be-an-author-under-the-copyright-act); [Jones Day (2026-03)](https://www.jonesday.com/en/insights/2026/03/jones-day-talks-women-in-ip--supreme-court-denies-review-of-thaler-v-perlmutter-ai-authorship-questions-remain)

**Reception**
- GDC State of the Game Industry 2026 (more than 2,300 respondents): 52% say generative AI harms the industry (30% in 2025, 18% in 2024), and only about 7% call it positive. Visual and technical artists are the most negative at 64%. Still, 36% use generative AI at work: 30% at studios versus 58% at publishing and marketing firms. — [GDC (primary)](https://gdconf.com/article/gdc-2026-state-of-the-game-industry-reveals-impact-of-layoffs-generative-ai-and-more/); [TechSpot](https://techspot.com/news/111128-more-than-50-game-developers-generative-ai-harming.html)
- In December 2025 the Indie Game Awards rescinded Clair Obscur: Expedition 33's Game of the Year and Debut awards because AI-generated placeholder textures shipped at launch, even though a patch replaced them five days later. — [Malay Mail (2025-12-21)](https://www.malaymail.com/news/tech-gadgets/2025/12/21/indie-game-awards-rescinds-honours-from-clair-obscur-expedition-33-for-genai-use/202718)
- A gamer survey run October to December 2025 found 85% negative toward generative AI in games, 62% "very negative" and 7.6% approving. AI for dynamic difficulty adjustment was net positive. The sponsor and method were not visible to me. — [Boing Boing (2025-12-20)](https://boingboing.net/2025/12/20/survey-finds-very-negative-attitude-toward-gen-ai-in-games.html)

### Inferences
- A mobile-only release faces no store disclosure duty for AI-made art today. Any later Steam/PC release would need disclosure, including AI-made store and marketing images.
- Because purely AI-generated art is not protectable in the US, a human-drawn or human-substantially-modified pipeline protects the game's distinctive identity. The project's own HTML icon generator, where a human authors the shapes, sits on the safer side.
- Even AI placeholders can cost reputation (the Clair Obscur case), so placeholder hygiene matters.
- The game uses an AI assistant to write code. Under Steam's 2026 rules such internal use is exempt; only player-visible AI output counts.

### Gaps
- I could not see the full Steamworks survey text after the January 2026 change, and the reports came through press.
- I did not research copyright status in Turkey or the EU for AI output. The Turkish Law on Intellectual and Artistic Works (FSEK) is not covered here.

## 5. Audio: UI and feedback sounds, music loops for long sessions, muted play, adaptive audio

### Takeaway
Assume most mobile players are muted: the best recent survey says over 90%. Every piece of feedback must therefore work visually, with haptics as the second channel. Sound should be a bonus layer of short, non-fatiguing UI cues and a seamless, unobtrusive loop that has been tested over long sessions.

### Cited Findings
- TapResearch (2022-05-18, n=2,400 mobile gamers, census-balanced): only 8% said they play with game sound on, and over 91% play with sound off. 58% of rarely/never-sound players have never made an in-game purchase. — [TapResearch](https://blog.tapresearch.com/how-sound-preferences-impact-player-engagement)
- Contradicting, older data from Appington/Amplify (2013, SDK telemetry): 73% played with volume at 10% or more (78% US, 58% UK, 90% China/Korea). It is dated and measures device volume, not in-game settings. — [TouchArcade (2013-11-05)](https://toucharcade.com/2013/11/05/73-of-mobile-gamers-play-with-the-sound-on/)
- YouGov/AudioMob found that 61% of mobile players listen to their own music while playing at least sometimes. — [AudioMob](https://audiomob.com/blog/yougov-survey)
- One developer's data showed only 2% of users turned off one particular soundtrack (2012 anecdote). — [Phil Hassey blog](https://www.philhassey.com/blog/2012/10/)
- Mobile audio plays on tiny speakers and is often muted, so assets must be small and cut through. UI sounds repeat thousands of times per session, so ear fatigue is a design target. — [IRPR Sound, mobile games](https://sounddesign.irpr.agency/applications/mobile-games/) (vendor); [Fab UI pack listing](https://www.fab.com/listings/984b76fa-c51c-4f42-8f74-71e1b01ad8f8) (vendor)
- GDC Audio Bootcamp XVIII "Loop Clinic" covers seamless, non-annoying loops for interactive music (only the description was accessible). — [GDC Vault 1025942](https://gdcvault.com/play/1025942/Audio-Bootcamp-XVIII-Loop-Clinic)
- Loop bugs, such as music that stops looping after an hour, appear only in real long sessions, so test audio over long play. — [Bugnet, UI sound design for indie games](https://bugnet.io/blog/ui-sound-design-for-indie-games)
- Playtest with audio off early to find where visual communication fails. Use haptics as feedback when audio is absent, and get input from players with hearing impairments. — [Wayline: muting audio](https://www.wayline.io/blog/muting-audio-game-design-innovation)
- Apple's haptics patents pair tactile output with audio, with audio as the richer complement. Because audio is not the only channel, muting does not undermine operability. — [USPTO 10228765](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/10228765)

### Inferences
- For a timed, return-later game, the key moments are a job finishing, delivery and stars. They need a visual plus haptic signature first and a sound second. Notification sounds are where audio actually gets heard.
- Respect the player's own music: don't duck or stop background music from other apps. This follows from the 61% who listen to their own music; the platform API detail was not researched.
- Adaptive audio for a calm management game can stay minimal. A rush state, a delivery sting and one ambient loop are enough. This is my inference; I found no sourced guidance specific to this genre.

### Gaps
- I found no current (2024-2026) large survey of muted play. The 2022 figure is the latest; the old figures conflict.
- I found no sourced, specific guidance on adaptive-audio techniques for mobile (for example vertical layering), and the Loop Clinic content was not accessible.
- I did not research the iOS/Android audio-session APIs (mixing with other apps).

## 6. Typography in games: readable fonts and localization (Turkish characters)

### Takeaway
Use large default text, offer size scaling if possible, provide a plain option if the font is stylised, and enforce contrast ratios. For Turkish, check glyph coverage (İ ı Ş ş Ğ ğ). Locale-aware case conversion and the font's `locl` feature matter as much as the glyphs: they explain many "missing İ" bugs.

### Cited Findings
- Microsoft's handheld guidance: essential text legible at 12 inches, at least 14 px tall at 1080p, recommended 18 px. Screen magnifiers do not replace minimum text size. — [Xbox handheld guidelines](https://devdocs.xbox.com/build/gdk-and-engines/handheld/handheld-guidelines-and-testcases); [XAG 101 text display](https://devdocs.xbox.com/gaming/accessibility/xbox-accessibility-guidelines/101)
- Contrast: 4.5:1 for standard text and 3:1 for large text. Even inactive or disabled text must meet 3:1. — [XAG 102 contrast](https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-102-contrast.md); [XAG version history](https://learn.microsoft.com/ar-sa/xbox/accessibility/xag-version-history)
- If stylised fonts are used, Xbox recommends offering a non-stylised option. Game Accessibility Guidelines say a choice of font size is ideal, with a large default as fallback. — [XAG 101](https://devdocs.xbox.com/gaming/accessibility/xbox-accessibility-guidelines/101); [gameaccessibilityguidelines.com](https://gameaccessibilityguidelines.com/?p=3285)
- Practitioner rule of thumb: 16pt body text and 20pt for key values and button labels. — [Glance / Affective learning centre](https://thisisglance.com/learning-centre/what-accessibility-features-do-gaming-apps-need-most) (blog)
- Turkish has dotted and dotless i in both cases. Generic uppercasing turns i into I, dropping the dot. Fonts need `idotless`, `idotaccent` and `dotaccentcomb` glyphs with correct Unicode mappings, plus a `locl` feature for Turkish. — [Glyphs: Localize your font, Turkish i](https://glyphsapp.com/learn/localize-your-font-turkish); [FontCreator tutorial](https://www.high-logic.com/font-editor/fontcreator/tutorials/localized-forms-turkish-i); [Wikipedia: Dotted and dotless I in computing](https://en.wikipedia.org/wiki/Dotted_and_dotless_I_in_computing)
- Game UI font packs often lack Ğ, Ş and İ, so "İstanbul" renders wrong. Several PC games broke on Turkish-locale systems because of culture-sensitive string handling, and forcing en-US culture fixed it. — [itch.io thread](https://itch.io/post/17366534); [Last Epoch forum](https://forum.lastepoch.com/t/capital-i-letter-looks-weird/44354); [Steam discussion](https://steamcommunity.com/app/1173590/discussions/0/2269195350119365224)

### Inferences
- Bitter covers Turkish (the project already checks this), but any `toUpperCase()` on Turkish strings in Dart is locale-insensitive by default and will turn "i" into "I" rather than "İ". Uppercase labels should be written pre-cased in the data or use a Turkish-aware conversion. This is my inference about Dart's behaviour and was not verified in this research.
- The 4.5:1 and 3:1 targets match the project's existing measured ≥5.1:1 status text, so the rule already in place is on the safe side.

### Gaps
- No source gave Flutter- or Dart-specific guidance on Turkish case mapping, and no mobile-platform (Apple HIG / Material) minimum type sizes were fetched in this pass.
