# CONTROL_METHODS round 3: `openBy` (anchor-resolving arg kind) + `setActivePage`

## Motivation

Batch b05 (2026-07-19) hit two more imperative methods the demo kit samples
need and the `CONTROL_METHODS` whitelist does not carry:

- **sap.m.sample.DatePickerHidden** (port `z2ui5_cl_ai_app_540`) — the
  sample's whole point is `DatePicker.openBy(oDomRef)`: three anchor
  controls (Button, icon Button, Link) open one hidden `DatePicker`
  (`hideInput="true"`). `openBy` is not whitelisted, so the 1:1 wiring
  (press → `follow_up_action( cs_event-control_by_id )` with method
  `openBy`) is rejected client-side and the picker never opens. There is
  no alternative: `DatePicker` has no public `open()` and no bindable
  open-state property (source-checked in `sap/m/DatePicker.js` — only
  `openBy`/`toggleOpen`, both unlisted).
- **sap.m.sample.ComparisonPattern** (port `z2ui5_cl_ai_app_536`) — the
  snapped/expanded header Carousels re-sync via
  `Carousel.setActivePage(vPage)`; unlisted, so the port dropped the
  re-sync (declared IMPROVISED).

## Current behavior

`app/webapp/core/FrontendAction.js` — `CONTROL_METHODS` has no `openBy` /
`setActivePage`; `castArg` has no kind that resolves a control id to a
**DOM ref**.

## Proposed change

```js
// castArg: new kind
case "domRef": {
  const c = (view && ViewSlots.byId(view.toUpperCase(), raw)) || ViewSlots.resolveById(raw);
  return c?.getDomRef?.() ?? c;
}

// CONTROL_METHODS additions
openBy:        ["domRef"],      // DatePicker/TimePicker/Menu... anchor
setActivePage: ["controlId"],   // sap.m.Carousel
```

`openBy` implementations across sap.m accept a control OR a DOM element;
passing the resolved element (fallback: the control) covers both. Scope
stays "imperative methods with no binding equivalent" — the whitelist
model of pr/control-call-whitelist and pr/control-method-args.

## Example (DatePickerHidden port)

```abap
client->follow_up_action( val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `HiddenDP` ) ( `` ) ( `openBy` )
                                           ( anchor_id ) ) ).
```

## Ports affected here

`z2ui5_cl_ai_app_540` (openBy path wired but client-rejected — IMPROVISED
declared, LIVE_TEST blocked on this request) and `z2ui5_cl_ai_app_536`
(Carousel re-sync dropped). The TimePicker/Menu "hidden picker" backlog
samples share the `openBy` need.
