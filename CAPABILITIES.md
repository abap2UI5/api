# CAPABILITIES.md — what abap2UI5 can express

The capability map for porting UI5 demo kit samples. **Read this before deciding
that a sample feature cannot be ported** — the most common generation mistake so
far was not wrong code but a wrong assumption about what abap2UI5 can do (a
Dialog declared "not expressible" although another port in this repo builds one;
CSS dropped although `core:HTML` can carry it). Every entry names the port that
proves it, so claims stay checkable.

Status legend: ✅ direct 1:1 · 🔶 expressible with a documented workaround ·
🧪 plausible, needs a LIVE-TEST port to confirm · ❌ not expressible today.

Maintenance rule (same discipline as AGENTS.md §10): whenever a port proves a
new technique, or disproves a ❌, update this table **in the same change** and
reference the port. Never write an `IMPROVISED:`/dropped note for a feature this
table marks ✅/🔶.

## Views & controls

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Any XML view structure (containers, aggregations, namespaces) | ✅ | `z2ui5_cl_api_xml` open/leaf/shut + `a()` | all ports |
| Aggregations filled by the controller in `onInit` (e.g. pre-set `tokens` on MultiInput) | ✅ | declare the aggregation in the view: `open( 'tokens' )` → `leaf( 'Token' )` per entry | missed in app 454 — the tokens aggregation is public since 1.16; do not skip these |
| Custom CSS (`style.css`, `html:style` blocks) | 🔶 | `core:HTML` leaf with the `content` **attribute** carrying `<style>…</style>` — the builder escapes attribute values, no CDATA node needed | apps 404/431 inject their sample `style.css` exactly this way (restored 2026-07-16, LIVE-TEST pending); 404 also uses `content` for `<h2>…</h2>` markup |
| Composite/array properties (RangeSlider `range="[lo,hi]"`) | 🔶 | split into the scalar sibling properties the control keeps in sync (`value`/`value2`) | app 472 |
| Literal line breaks inside attribute values (`&#xA;` in the original) | ✅ | write the break as `\n` in a `\|...\|` template — `xml_escape` emits it as `&#xA;`/`&#xD;`/`&#x9;` so it survives XML attribute-value normalization | app 445 (`noDataText`); builder fix 2026-07-16 |
| Raw text / CDATA child nodes | ❌ | `z2ui5_cl_api_xml` has element+attribute nodes only; for markup/CSS use the `core:HTML` `content` attribute (row above) | app 404 NOTES |

## Popups & messages

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Controller-built `sap.m.Dialog` (`new Dialog({...}).open()`) | ✅ | build a `core:FragmentDefinition` → `Dialog` with the same builder, show with `client->popup_display( )`, close via `client->_event_client( client->cs_event-popup_close )` | app 469; app 529 now builds its error Dialog the same way (its earlier toast substitution was a wrong improvisation) |
| `sap.m.MessageBox` | ✅ | `client->message_box_display` (actions, initialFocus, styleClass supported) | app 447 |
| `sap.m.MessageToast` | ✅ | `client->message_toast_display` | apps 448, 526 |

## Models & binding

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| JSON model data | ✅ | ABAP `VALUE #( … )` + `client->_bind_edit` (never `_bind`) — keep the data verbatim, full row set | AGENTS §5; silent row subsets bit apps 433/440/441 |
| Two-way property binding incl. live client-side updates | ✅ | shared `_bind_edit` path on both controls — no event round-trip needed | app 527 (Switch↔Select), app 471 |
| Expression bindings (`{= … }`) over bound paths | ✅ | compose the captured `_bind_edit` handle into the expression string | app 421 (the AGENTS §5 worked example) |
| Imperative controller logic that only derives view state (setWidth/setExpanded from a control value) | 🔶 | prefer a pure expression binding over an event round-trip (`{= ${slider} + '%' }`) | app 421 is the pattern; the avoidable round-trips in 486/530 were removed 2026-07-16 (LIVE-TEST pending) |
| Nested tables / tree binding (`items="{path: '/'}"` over nested `nodes`) | 🧪 | nested ABAP table types serialize into the default model | app 487 (LIVE-TEST pending) |
| Named models (`img>`, `device>`, `mvc` view models) | ❌ | one default model only — flatten into it or resolve statically, always with an `IMPROVISED:` note | apps 420, 433, 434, 473 |
| `sap.ui.Device` / device model bindings | ❌ | not available server-side — fix the value, note it | apps 433, 473 |
| Binding `sorter` (no grouping, static data) | 🔶 | `SORT` the ABAP table once + inline comment + NOTES bullet | apps 440, 527 |
| Binding `sorter` with `group: true` + default group headers | 🧪 | keep a raw binding-info string `{path: '…', sorter: {path: '…', group: true}}` — UI5 parses it client-side; only a *custom* `groupHeaderFactory` is out | app 452 unrolled statically instead; worth a LIVE-TEST |
| Composite binding types / formatters (`sap.ui.model.type.Currency`, `Formatter.js`) | ❌ | preformat the value in ABAP, bind the result; note it | apps 440, 460 |
| MessageManager / `message>` model | ❌ | bind an equivalent hardcoded table | app 449 |

## Events

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Controller event handlers | ✅ | `client->_event( val = 'NAME' … )` + `check_on_event( )` CASE branches | all interactive ports |
| Passing event/source values to the backend | ✅ | `$`-prefixed `t_arg` forms: `${COL}`, `$event.oSource.sId`, `${$parameters>/value}` — never a bare `{COL}` | AGENTS §5; apps 486, 526 |
| Boolean event parameters | 🔶 | arrive as `abap_bool` (`X`/space) — map back to `true`/`false` when echoing to the UI | app 421 (correct), app 422 (echoes raw `X`) |
| Reading control-internal state via `$parameters>/…/mProperties/…` | ❌ | private UI5 internals, fragile across patches — restructure to a two-way binding or a public parameter instead | apps 401/474/530 were all migrated off it (2026-07-16); pattern-lint blocks any new use |
| Controller-read list selection (`getSelectedItems`, FacetFilter/List multi-select) | 🧪 | bind `selected="{FLAG}"` two-way on the items — the flags arrive with every event, and clearing them server-side resets the selection; no event payload needed | app 401 (selected flags), app 474 (two-way selectedKey) — both LIVE-TEST pending |
| Opening external URLs (`URLHelper.redirect`) | ✅ | `client->_event_client( client->cs_event-open_new_tab, t_arg = ( url ) )` | app 460 |
| Client-side-only behaviour with no backend effect | ✅ | `client->_event_client( … )` frontend actions | overview app popup close |
