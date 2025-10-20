# Review Screen Motion & Delight Brief

Purpose: Make the question/answer experience feel dynamic, rewarding, and habit-forming without being noisy. Celebrate progress with a “you win” vibe and a satisfying pop score card.

## Experience Goals
- Instant comprehension: card flip reveals answer with clear motion.
- Momentum: visible progress and streaks encourage another question.
- Reward: big, delightful celebration at session completion.
- Flow: animations are fast, fluid, and don’t block input.

## Core Interactions
1. Card Flip (Question → Answer)
   - Tap reveals answer via 3D flip (Y axis), easing: fastOutSlowIn, 280–320ms.
   - Subtle depth shadow during mid-flip.
   - Optional haptic: light impact on flip.

2. Grade/Response Buttons (Again / Hard / Good / Easy or similar)
   - On press: scale down to 0.96 then up to 1.0 (80–120ms), ripple effect.
   - Correct answer increments streak counter with small confetti burst in corner.
   - Incorrect answer shakes the card slightly (X axis, 12–16px) 120ms.

3. Progress & Streak
   - Top progress bar animates smoothly between questions.
   - Streak badge pulses on increment, number counts up quickly.
   - Streak breaks: flash red on the badge.

4. Session Complete
   - “You Win” overlay with celebratory animation:
     - Background fade-in + slight blur.
     - Confetti burst (2–3s) with colorful palette.
     - Pop Score Card: scales from 0.9 → 1.05 → 1.0 (springy), 350–450ms.
     - Score tick-up counters: total correct, accuracy %, time spent.
     - CTA buttons (Review mistakes / Back to Decks) with subtle glow.

## Motion System
- Timing
  - Fast: 80–120ms (button micro-interactions)
  - Standard: 240–320ms (flip, progress)
  - Celebration: 350–700ms (score pop, counters)
  - Confetti duration: 2–3s
- Curves
  - Entrance: Curves.easeOutCubic
  - Emphasis: Curves.elasticOut (light) or easeOutBack
  - Flip: Curves.fastOutSlowIn
- Stagger
  - Score card lines count up sequentially with 120–160ms stagger

## Visuals
- Keep within Material 3 theme.
- Use Hero transitions from deck to review header when possible.
- Pop Score Card layout:
  - Big “Great job!” title
  - Score rows with icons (check, timer, accuracy)
  - Confetti overlay above everything
  - Primary CTA, secondary text button

## Accessibility
- Respect “reduced motion”: fall back to quick fades and counters without flip.
- Maintain 4.5:1 contrast.
- All actions reachable via keyboard.

## Success Metrics
- Higher completion rates for sessions.
- Increased average streak count.
- Reduced drop-offs mid-session.

## Implementation Notes
- Use flutter_animate for chained effects, ImplicitlyAnimated/RepaintBoundary where helpful.
- Use an AnimationController for flip + progress.
- ConfettiController for win screen and mini corner bursts.
- Keep rebuild scope narrow; prefer ValueListenable/StatefulBuilder for hotspots.
