# pr/menu-toggle-openby — an anchored *toggle* for openBy-style popups

## Motivation

The demo kit sample
[`Menu`](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/Menu)
opens a `sap.m.Menu` from a button and **toggles** it: pressing the button
again while the menu is open **closes** it (controller `onPress` branches on
`this._oMenuFragment.isOpen()`).

This repo's **app 060** (`z2ui5_cl_ai_app_060`) reproduces the open via the
`openBy` frontend action (the golden app-016 pattern:
`follow_up_action( cs_event-control_by_id, openBy )` anchored to
`$event.oSource.sId`). But the **toggle/close-on-second-press** branch cannot
be reproduced and is dropped (declared): each press always (re-)opens.

## Current behavior

- `CONTROL_METHODS` (`app/webapp/core/FrontendAction.js`) whitelists **both**
  `openBy: ["domRef"]` and `close: []` — so the backend can open *or* close
  the menu.
- What it **cannot** do is decide *which*, because the popup's open/closed
  state lives entirely client-side: an item click, an outside click or the ESC
  key closes the menu **without notifying the backend**, so a server-side
  "is it open?" mirror drifts immediately. The sample's toggle relies on the
  client-side `isOpen()` check, which has no server-reachable equivalent.

## Proposed change

Add a single **client-side** anchored-toggle method to the whitelist so the
decision stays where the state is:

```js
// FrontendAction.js CONTROL_METHODS
toggleBy: ["domRef"],   // open the control anchored to the domRef if closed,
                        // close it if already open (mirrors openBy)
```

Implementation mirrors the existing `openBy` domRef resolution and calls
`oControl.isOpen() ? oControl.close() : oControl.openBy(oAnchor)` — one
client-side branch, no backend round-trip, no state to mirror.

## Example (port side)

```abap
WHEN `OPEN_MENU`.
  client->follow_up_action( val   = client->cs_event-control_by_id
                            t_arg = VALUE #( ( `theMenu` ) ( `` )
                                             ( `toggleBy` )
                                             ( client->get_event_arg( ) ) ) ).
```

app 060's dropped toggle branch then becomes a faithful 1:1.

## Scope / notes

- Small, self-contained: one whitelist entry reusing the `domRef` arg kind.
- Applies to the whole openBy family (Menu, Popover, …) where a
  press-to-toggle button is idiomatic.
- **Priority: low** — the always-open behaviour is a minor UX deviation, not a
  rendering/data bug. Filed to record the gap per the pr/ convention; not
  blocking any port.
