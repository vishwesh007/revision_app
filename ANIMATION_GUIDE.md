# Animation Playbook

## Home Screen Animation Timeline

```
TIME          ELEMENT                  ANIMATION
────────────────────────────────────────────────────────────────
0ms           App Bar                  Mount
0ms           └─ Title                 Shimmer (repeating)
300ms         └─ Settings Button       Scale + FadeIn

0ms           Content Area             Mount
100ms         Review Button            FadeIn + SlideY
              └─ Icon                  Pulse (repeating) + Shimmer

200ms         "Your Decks" Title       FadeIn + SlideX (left)
300ms         "Import" Button          FadeIn + SlideX (right)
375ms         Deck 1                   SlideY + FadeIn
750ms         Deck 2                   SlideY + FadeIn
1125ms        Deck 3                   SlideY + FadeIn
(staggered by 375ms per deck)
```

## Empty State Animation

```
TIME          ELEMENT                  ANIMATION
────────────────────────────────────────────────────────────────
0ms           Empty Icon               FadeIn (600ms)
200ms         Empty Icon               Scale (pop effect)
800ms         Empty Icon               Shake (attention)
400ms         Title Text               FadeIn + SlideY
600ms         Subtitle Text            FadeIn
800ms         Import Button            FadeIn + Scale
1800ms        Import Button            Shimmer (repeating)
```

## All Caught Up Celebration

```
TIME          ELEMENT                  ANIMATION
────────────────────────────────────────────────────────────────
0ms           Confetti                 🎉 Explosive burst (3s)
0ms           Checkmark Icon           Pulsing scale (repeating)
0ms           Success Card             FadeIn + SlideX
```

## Statistics Card

```
TIME          ELEMENT                  ANIMATION
────────────────────────────────────────────────────────────────
0ms           Card                     FadeIn + SlideY (400ms)
0ms           Icons                    Pulsing scale (1500ms repeat)
200ms         Stat Values              FadeIn
300ms         Stat Labels              FadeIn
```

## Animation Patterns

### Entrance Animations
```dart
// Fade + Slide combo
.animate()
.fadeIn(delay: 100.ms)
.slideY(begin: 0.2, end: 0)

// Fade + Scale combo
.animate()
.fadeIn(delay: 800.ms)
.scale(delay: 800.ms)
```

### Attention Animations
```dart
// Pulsing effect (repeating)
.animate(onPlay: (controller) => controller.repeat(reverse: true))
.scale(duration: 800.ms, begin: Offset(1.0, 1.0), end: Offset(1.15, 1.15))

// Shimmer effect (repeating)
.animate(onPlay: (controller) => controller.repeat())
.shimmer(duration: 2000.ms, delay: 1000.ms)
```

### Error Animations
```dart
// Shake effect
.animate()
.shake()

// Retry button
.animate()
.fadeIn(delay: 300.ms)
.scale(delay: 300.ms)
```

### List Animations
```dart
// Staggered list items
AnimationConfiguration.toStaggeredList(
  duration: const Duration(milliseconds: 375),
  childAnimationBuilder: (widget) => SlideAnimation(
    verticalOffset: 50.0,
    child: FadeInAnimation(child: widget),
  ),
  children: items,
)
```

### Hero Transitions
```dart
// Deck avatar navigation
Hero(
  tag: 'deck-${deck.id}',
  child: CircleAvatar(...),
)
```

### Confetti Celebration
```dart
// In State class
late ConfettiController _confettiController;

@override
void initState() {
  super.initState();
  _confettiController = ConfettiController(
    duration: const Duration(seconds: 3)
  );
}

// Trigger on condition
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (mounted) _confettiController.play();
});

// Overlay widget
ConfettiWidget(
  confettiController: _confettiController,
  blastDirectionality: BlastDirectionality.explosive,
  shouldLoop: false,
  colors: [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
)
```

## Animation Performance Tips

1. **Use flutter_animate**: More efficient than AnimatedBuilder
2. **Limit repeating animations**: Only pulse important CTAs
3. **Stagger list items**: Prevents layout thrashing
4. **Hero transitions**: GPU-accelerated shared element transitions
5. **Dispose controllers**: Always dispose in State.dispose()
6. **Avoid layout changes**: Animations should use transforms, not size changes
7. **Test on device**: Emulators may show slower animation performance

## Accessibility Considerations

```dart
// Future enhancement: Respect reduced motion preferences
import 'package:flutter/foundation.dart';

// In build method
final reducedMotion = MediaQuery.of(context).disableAnimations;

// Apply animations conditionally
widget
  .animate(
    effects: reducedMotion ? [] : [
      FadeEffect(),
      ScaleEffect(),
    ],
  )
```

## Debug Animations

```dart
// Slow down animations for debugging
import 'package:flutter/scheduler.dart';

// In main() before runApp
timeDilation = 2.0; // 2x slower (default is 1.0)
```
