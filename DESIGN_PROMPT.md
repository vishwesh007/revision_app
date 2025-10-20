# Revision Buddy – UI/UX Design Prompt

## 1. Product vision
- Help learners retain knowledge through spaced repetition with minimal friction.
- Make importing content effortless (JSON/SQLite), reviewing fast, and progress clear.

## 2. Design principles
- Clarity over clutter: one primary action per screen.
- Speed matters: 1–2 taps to start a review.
- Predictable patterns: consistent placement, labels, and colors.
- Accessible by default: contrast AAA where possible, scalable text, large hit targets.
- Calm UI: reduce cognitive load with whitespace and hierarchy.

## 3. Target personas
- Student Sprint (16–25): Quick daily revision, mobile-first, wants reminders.
- Upskiller (25–40): Imports custom decks, wants daily goals and stats.
- Educator (30–55): Prepares content, relies on reliable import/export.

## 4. Information architecture
- Home (Due today, Quick Review, Add/Import)
- Decks (List, create, manage)
- Review (Question → Answer → Rate)
- Import (Asset/File/URL; examples; validation)
- Stats (Streaks, accuracy, due curve)
- Settings (Notifications, backup/restore, theme)

## 5. Key flows (success criteria)
- Start a review: Open app → tap "Start review" → finish 10 cards in <2 min.
- Import data: Import → pick file → success feedback in <10s or clear error.
- Enable reminders: Settings → toggle → pick time → confirmation toast.

## 6. Visual language
- Color scheme (light):
  - Primary: Indigo 600 (#4F46E5)
  - Secondary: Emerald 500 (#10B981)
  - Surface: #FFFFFF / #0B1220 (dark)
  - Accent (warning): Amber 500 (#F59E0B)
  - Error: Rose 500 (#EF4444)
- Typography: Inter or system font; bold weights for headings, 16px base body.
- Corners: 12px radius; elevation minimal; focus ring 2px primary.
- Iconography: Rounded; sparse; use motion sparingly.

## 7. Components
- App bar: Title + optional action (help/settings).
- Primary button: Filled, large touch target, label-driven.
- Secondary button: Tonal/outlined.
- Card: Deck/question blobs with title, subtile, meta.
- Snackbars: Success/Failure with concise messages.
- Empty state: Illustration + call-to-action.

## 8. Motion & feedback
- Subtle transitions (200ms). Review flip: fade/scale 95% → 100%.
- Loading: Circular progress with descriptive text.
- Success: Check icon + green snackbar.
- Error: Red snackbar with actionable hint.

## 9. Accessibility
- Text scaling to 200% without clipping.
- Contrast >= 4.5:1 for text.
- Large tap targets (min 44x44).
- Semantics labels for buttons and dynamic content.

## 10. Content tone
- Encouraging, concise, non-judgmental.
- Examples: "Nice! 10 cards done" "Couldn’t import. Try JSON or .db/.sqlite."

## 11. Metrics
- Daily active reviews, completion time, import success rate, error rate.
- Notification opt-in rate and click-through.

## 12. Deliverables to implement now
- Unified theme (ColorScheme + Typography + rounded shapes).
- Consistent app bar and scaffold.
- Polish Import screen: clearer steps, file-type chips, stronger feedback.
- Empty states for Decks and Review.
- App icon: stylized RB card stack with indigo accent.

## 13. Nice-to-have (later)
- Dark mode theme.
- Onboarding coach marks.
- Haptics for review success.
- Animations on card flip.
