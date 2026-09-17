# Accessibility and UX checklist

Use this checklist before merging a new page or materially changing an existing
one. Test at 320px mobile, 768px tablet, 1366px laptop, and a wide desktop.

## Structure and navigation

- [ ] One clear page heading and descriptive section headings.
- [ ] Every control has a visible label or an accessible name.
- [ ] Logical keyboard order; Enter/Space activate controls and Escape closes dialogs.
- [ ] A keyboard focus indicator remains visible in light and dark modes.
- [ ] Navigation links identify their destination and do not leave the mobile menu open.

## Forms and safeguards

- [ ] Required fields, optional fields, errors, and successful saves are clear.
- [ ] Modal dialogs trap focus, return focus when closed, and have an accessible close control.
- [ ] Narrative forms use unsaved-change protection before close, refresh, or navigation.
- [ ] Destructive actions use a confirmation dialog with the exact target named.

## Responsive presentation

- [ ] No page-level horizontal scrolling at 320px.
- [ ] Dense desktop tables have a mobile card/list alternative where practical.
- [ ] Touch controls are at least 44px high or have an equivalent forgiving target.
- [ ] Long framework text wraps without truncation or overlap.
- [ ] Survey assessment remains vertical-first on mobile.

## Visual access and output

- [ ] Text and interactive-state contrast are readable in light and dark modes.
- [ ] Colour is never the only way an outcome, risk, or status is communicated.
- [ ] Loading, empty, and error states are understandable without visual inference.
- [ ] Print/PDF layouts have a title, source context, readable margins, and no navigation chrome.
- [ ] Reduced-motion preference does not leave information inaccessible.
