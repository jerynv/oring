---
name: Oring
description: A private night-sky almanac for direct ring observations.
colors:
  paper-light: "#f7f5ef"
  paper-dark: "#101b25"
  ink-light: "#172b38"
  ink-dark: "#f4f1e9"
  ink-secondary-light: "#465969"
  ink-secondary-dark: "#c4d0d7"
  muted-light: "#5e6b74"
  muted-dark: "#acc0cb"
  amber-light: "#99520f"
  amber-dark: "#f2ac63"
  rule-light: "#d8ddd8"
  rule-dark: "#344450"
  chart-light: "#204d6c"
  chart-dark: "#5b9fc2"
  stage-light-light: "#78a9b7"
  stage-light-dark: "#a6cbd4"
  rem-light: "#327868"
  rem-dark: "#8ad0b8"
  awake-light: "#b37530"
  awake-dark: "#e4aa69"
  alert-light: "#a6432b"
  alert-dark: "#ed8d77"
typography:
  display:
    fontFamily: "New York, Georgia, serif"
    fontSize: "30pt, scaled by Dynamic Type"
    fontWeight: 400
  welcome:
    fontFamily: "New York, Georgia, serif"
    fontSize: "44pt, scaled by Dynamic Type"
    fontWeight: 400
  body:
    fontFamily: "San Francisco, sans-serif"
    fontSize: "18pt"
    fontWeight: 400
  control:
    fontFamily: "San Francisco, sans-serif"
    fontSize: "iOS body"
    fontWeight: 600
  readout:
    fontFamily: "SF Mono, monospace"
    fontSize: "20pt, scaled by Dynamic Type"
    fontWeight: 500
  chart-label:
    fontFamily: "SF Mono, monospace"
    fontSize: "10–12pt, scaled by Dynamic Type"
    fontWeight: 400
rounded:
  plot-marker: "3pt"
  small-card: "10pt"
  input: "14pt"
  primary-action: "16pt"
spacing:
  compact: "10pt"
  field: "16pt"
  report: "20pt"
  page: "24pt"
  section: "26pt"
components:
  welcome-primary-button:
    backgroundColor: "{colors.amber-light}"
    textColor: "{colors.paper-light}"
    typography: "{typography.control}"
    rounded: "{rounded.primary-action}"
    height: "54pt minimum"
  pairing-primary-button:
    backgroundColor: "{colors.ink-light}"
    textColor: "{colors.paper-light}"
    typography: "{typography.control}"
    rounded: "{rounded.input}"
    height: "54pt minimum"
  pairing-key-field:
    rounded: "{rounded.input}"
  readout:
    typography: "{typography.readout}"
---

# Design System: Oring

## Overview

**Creative North Star: "The Night-Sky Almanac"**

Oring treats each night as a dated observation. Warm paper in light appearance and deep ink in dark appearance make the same calm reading surface. The date and welcome line carry the New York serif; measurements and plotted time carry monospaced precision. The plots provide the detail, while the surrounding screen leaves room to read them.

The app is native SwiftUI. Use native navigation, sheets, segmented selection, Dynamic Type, and accessible chart summaries. Sample observations are explicitly labeled in amber before the dated report. Connection and reset copy stays literal because the data source and consequences matter.

**Key Characteristics:**
- Light and dark are paired appearances of one semantic palette.
- A large serif moment introduces a screen; data remains compact and exact.
- Fine dividers, aligned lanes, and whitespace organize dense signals.
- Amber identifies the entry action and sample provenance.

## Colors

The paired tokens in the frontmatter are the actual `Obs` light and dark values; switch them with iOS appearance rather than blending the palettes.

### Primary
- **Almanac Ink:** `ink-light` / `ink-dark` carries titles, values, and primary ring controls.
- **Invitation Amber:** `amber-light` / `amber-dark` carries the welcome action, text action, and sample disclosure.

### Secondary
- **Signal Blue:** `chart-light` / `chart-dark` carries overnight signal lines and the deep-sleep stage.
- **REM Green:** `rem-light` / `rem-dark` distinguishes REM and positive status.
- **Awake Ochre:** `awake-light` / `awake-dark` distinguishes awake segments.

### Neutral
- **Paper and Night:** `paper-light` / `paper-dark` is the full-screen canvas.
- **Secondary Ink:** `ink-secondary-light` / `ink-secondary-dark` carries explanatory copy and plot labels.
- **Muted Ink:** `muted-light` / `muted-dark` carries tertiary copy.
- **Hairline:** `rule-light` / `rule-dark` separates sections and outlines fields.
- **Light-Sleep Blue:** `stage-light-light` / `stage-light-dark` distinguishes light sleep.
- **Alert Terracotta:** `alert-light` / `alert-dark` marks destructive controls.

**The Semantic Color Rule.** Stage colors identify stages; status colors appear only when the underlying status is known. Amber on a sample report identifies provenance.

## Typography

**Display Font:** iOS system serif (New York on current iOS, with system serif fallback).
**Body Font:** San Francisco through SwiftUI's system font.
**Measurement Font:** iOS system monospaced face with monospaced digits.

### Hierarchy
- **Welcome:** regular system serif (44 pt base, scaled with Dynamic Type); one unboxed statement.
- **Dated headline:** regular system serif (30 pt base, scaled with Dynamic Type).
- **Body explanation:** regular system sans (18 pt on the welcome screen); native body, subheadline, and footnote roles in controls and pairing.
- **Readout:** medium monospaced value (20 pt base, scaled with Dynamic Type); use its unit and nearby caption to explain the number.
- **Plot label and axis:** monospaced (10–12 pt base, scaled with Dynamic Type); align labels, values, and hours precisely.

**The Dated Observation Rule.** Reserve the large serif for the welcome statement and dated or page titles. Use sans for actions and explanation, and mono for measured data.

## Layout

The welcome screen is a single vertical column with a wide arc and generous blank space. Pairing content is capped at 520 pt and inset 24 pt; the report uses a 20 pt inset and 26 pt vertical rhythm. A thin rule separates report sections without boxing the whole report. The overnight plot aligns a hypnogram and available heart rate, HRV, oxygen, temperature, and motion lanes on one time axis. Missing series are omitted rather than drawn as zero.

At accessibility text sizes, summary readouts reflow to two columns and clinical grids to one column. Plot dimensions and labels use `@ScaledMetric`. Keep native controls large enough to operate and preserve the chart's spoken summary.

**The Shared Clock Rule.** Signals for one night share one horizontal time axis and a scrub position; stage timing remains visible alongside them.

## Elevation & Depth

The app is predominantly flat. Paper/night canvas, fine rules, and slight tonal field or grouped-row fills create depth. Native iOS sheets and segmented controls keep their system material. The custom cards use a thin border; no custom hard shadow is part of the system.

## Shapes

The main action uses a gently rounded rectangle (16 pt); pairing fields and controls use 14 pt corners, and small bordered cards use 10 pt. Chart marks stay precise: square stage runs, 3 pt rounding on the compact stage bar, thin lines and rules. Circular controls follow native navigation conventions.

## Components

### Buttons
- **Welcome primary:** full-width amber fill, paper text, native semibold body type, 54 pt minimum height and 16 pt corners.
- **Pairing primary:** full-width ink fill and paper text, 54 pt minimum height and 14 pt corners; disabled state uses the rule color and muted text.
- **Text action:** sample-night entry is an unfilled amber action with a 48 pt minimum height.
- **Secondary:** pause and Done remain native controls, with ink text and an outline where the pairing screen needs one.

### Cards / Containers
- **Daily card:** paper fill, 1 pt hairline border, 10 pt continuous corners and 18 pt internal padding.
- **Grouped support rows:** a low-contrast rule-colored fill and 16 pt corners; fine row separators keep each action distinct.

### Inputs / Fields
- **Pairing key:** monospaced secure entry with a reveal control, light rule fill, rule stroke and 14 pt corners. Focus changes the stroke to muted ink. The field explains the 32-character format when input is invalid.

### Navigation
- Use a native navigation stack, native sheet, and segmented Sleep/Activity picker. Sample provenance sits above the dated report. The report's long content scrolls below the fixed navigation controls.

### Overnight plot
- The hypnogram uses four stage colors and a stepped path. Each available signal occupies an aligned lane; labels and live values sit in a left gutter. A horizontal drag displays the shared time cursor, then releases it. A spoken summary names the stages and available signals.

## Do's and Don'ts

### Do:
- **Do** label sample data before showing measurements.
- **Do** pair every light color with its dark semantic counterpart.
- **Do** show real REM timing and available signals on the shared night axis.
- **Do** keep account, pairing, and destructive consequences in plain native copy.

### Don't:
- **Don't** invent a readiness score or use stage color as generic decoration.
- **Don't** wrap the report in heavy cards or add hard offset shadows.
- **Don't** imply that absent signals were measured.

Current uppercase tracking in some tags and readout captions, plus some SF Symbol-led rows, is present in the implementation but is not canonized as a general editorial kicker or decorative icon system. The report retains technical captions because they label measurements. The current design review disposition is **ship after fixes**; real-ring pairing and sync still require a physical-device check.
