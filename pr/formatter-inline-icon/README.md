# pr/formatter-inline-icon — a curated `inlineIcon` helper for formatted-text inline icons

## Motivation

`sap.m.MessageStrip` with `enableFormattedText="true"` can embed **inline
icons** in its text. The demo kit sample
[`MessageStripWithEnableFormattedText`](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/MessageStripWithEnableFormattedText)
builds those strings in its controller with
`sap.m.MessageStripUtilities.getInlineIcon("sap-icon://message-success")`,
which resolves the icon URI to the icon-font glyph and returns the exact
markup UI5 expects:

```html
<span class="sapMMsgStripInlineIcon" ...>&#xe1c1;</span>
```

Porting that sample (this repo's **app 062**,
`z2ui5_cl_ai_app_062`) has no equivalent. The port must **hardcode** the
`<span class="sapMMsgStripInlineIcon">&#x....;</span>` markup and **guess the
codepoints** — recorded as an `IMPROVISED` deviation with the codepoints
flagged "illustrative". That is fragile (the glyph for a given `sap-icon://`
name is only known to the icon-font registry) and cannot be verified offline.

## Current behavior

- The curated formatter module `app/webapp/model/formatter.js` (served as
  `z2ui5/model/formatter`, emitted by
  `z2ui5_cl_app_formatter_js.clas.abap`) ships general-purpose value
  formatters (`weightState`, `stockStatusState`/`-Icon`, `round2DP`,
  `dimensions`, date helpers …) and is CSP-clean (real served script, no
  runtime code generation).
- There is **no** helper that turns a `sap-icon://<name>` URI into its inline
  glyph markup, so a MessageStrip's formatted text cannot embed a real icon
  without the app knowing the private codepoint.

## Proposed change

Add one curated function to `app/webapp/model/formatter.js` (and re-export via
`z2ui5.Util` like the date helpers), resolving the glyph at runtime through
the public `sap.ui.core.IconPool` — CSP-clean, no code generation:

```js
// sap-icon://<name> -> the inline-icon markup MessageStrip formatted text
// expects (mirrors sap.m.MessageStripUtilities.getInlineIcon).
inlineIcon(sIconUri) {
  const info = sap.ui.require("sap/ui/core/IconPool")?.getIconInfo(sIconUri);
  if (!info) { return ""; }
  return '<span class="sapMMsgStripInlineIcon" style="font-family:\'' +
         info.fontFamily + '\'">' + info.content + '</span>';
}
```

(Exact class/attribute set should be aligned 1:1 with the current
`MessageStripUtilities.getInlineIcon` output.)

## Example (port side)

With the helper available, the inline-icon text becomes a real binding
instead of a hardcoded guess — e.g. an expression/parts binding that composes
the sentence from data + `Formatter.inlineIcon('sap-icon://sys-enter-2')`,
or (for a fully server-built string) an ABAP-side re-export so `model_init`
can assemble the exact markup. Either way app 062's `inlineIconsHelper`
`IMPROVISED` deviation is replaced by a faithful 1:1 rendering.

## Scope / notes

- General-purpose (any formatted-text control that embeds icons —
  MessageStrip, FormattedText), fits the "curated, grows via framework PRs"
  contract of the module.
- Does **not** need an ABAP API change; a served-module addition only.
- Low risk: read-only use of a public UI5 API (`IconPool`).
