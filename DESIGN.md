---
name: Oring
description: A quiet, native space for nights read directly from a ring.
colors:
  canvas: "#080e1e"
  ink: "#f6f8ff"
  secondary: "#c7d1e5"
  muted: "#9caec9"
  action: "#b8c9ff"
  divider: "#26344d"
  deep: "#6e8ff4"
  light: "#a9c3eb"
  rem: "#9fddcf"
  awake: "#e4c5a2"
typography:
  display: "San Francisco, system bold"
  body: "San Francisco, system regular"
  measure: "San Francisco with tabular digits"
spacing:
  page: "28pt onboarding; 24pt home"
  section: "34pt onboarding; 20pt report"
rounded:
  primary-action: "18pt"
  choice: "20pt"
---

# Design System: Oring

## Direction

Oring feels like opening a quiet window into the night. A solid deep navy canvas leaves the data and controls at ease. Apple system type carries every headline, explanation, control, and measurement. The ring uses one original, unbranded still image in onboarding and sync. There are no background stars, orbit lines, or decorative dots.

## First Run

The welcome screen has one headline, the ring render, a short promise of direct Bluetooth sleep data, and a clear Get started action. Pairing moves through one question at a time: prepare the ring, identify whether it has an existing key, then connect or create a key for an already factory-reset ring. Show progress in its own step. Keep advanced actions and diagnostics one tap away. Explain that factory reset erases unsynced data before the fresh-ring path.

## Sleep Report

Lead with sleep duration and REM, then the overnight hypnogram and four stage colors. Keep heart, HRV, oxygen, temperature, and movement aligned to the same clock when expanded. Put clinical metrics and interpretation behind a second disclosure. Never plot absent signals as zero or present sample data as a measured night.

## Native Behavior

Use SwiftUI navigation, sheets, text fields, and controls. Every action has at least a 44pt target. Keep the screen legible at larger text sizes, preserve chart accessibility summaries, and use status colors only when a state is known. The sync button keeps one size while it moves from ready to loading to a short green success state, then shows the last check. The battery indicator is a restrained 80% arc around the still ring image. Empty states have a soft local glow and clear next step without icon tiles. The ring and data remain local to the iPhone. Fresh pairing and event sync have been exercised on a physical ring; a recorded overnight report still needs a hardware test before claiming sleep-stage compatibility.
