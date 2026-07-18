# App-supplied client-side formatter functions (`z2ui5.fmt.*` registry)

## Summary

Demo kit samples routinely bind with **custom JS formatter functions**
(`Formatter.js` modules, `formatter: '.fn'` controller methods,
`groupHeaderFactory`, list-item factories). abap2UI5 has no way for an app to
supply such a function, so CAPABILITIES.md marks the category ❌ and ports must
preformat values in ABAP - which freezes them to render time and breaks 1:1
bindings that reformat client-side.

## Motivation

Ports in this repo that carry a deviation only because a client-side function
cannot be supplied:

- **[Table](https://sdk.openui5.org/entity/sap.m.Table/sample/sap.m.sample.Table)**
  (`z2ui5_cl_ai_app_401`) - `Formatter.js` `weightState` maps a numeric weight
  to a `State` (`Success/Warning/Error`); the port preformats the state into an
  extra ABAP column.
- **[MultiComboBoxGrouping](https://sdk.openui5.org/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping)**
  (`z2ui5_cl_ai_app_452`) - the custom `groupHeaderFactory '.getGroupHeader'`
  happens to match UI5's default headers, so the port survives; any factory
  that does more would not.
- **[Text](https://sdk.openui5.org/entity/sap.m.Text/sample/sap.m.sample.TextMaxLines)**-style
  samples with per-row factories (`z2ui5_cl_ai_app_481`) - rows are unrolled
  statically because a factory function cannot be expressed.

## Current behavior

The framework already has BOTH halves of the mechanism - they are just not
connected for apps:

- `app/webapp/Util.js` is published as the **`z2ui5.Util` global exactly so XML
  view formatter strings can reference it** (`Component.js`: "z2ui5.Util global
  (XML view formatter strings) or via core:require"). Framework-shipped
  formatters work today; app-shipped ones do not exist.
- The backend can already ship JS to the client: `S_FOLLOW_UP_ACTION.CUSTOM_JS`
  snippets are executed after render (`Server.js` `_runCustomJs`), including
  raw-expression Format A (under a CSP that allows `unsafe-eval`).

## Proposed change (sketch)

A small named-formatter registry on the client plus one client API to fill it:

```abap
" once, at view_display time - the body is compiled once and cached
client->register_formatter(
  name = `weightState`
  js   = `(weight) => weight < 1000 ? 'Success' : weight < 2000 ? 'Warning' : 'Error'` ).
```

Client side: `z2ui5.fmt = {}`; `register_formatter` compiles the body once
(`Function` - same CSP condition as custom-JS Format A) and stores it as
`z2ui5.fmt.weightState`. Views then bind the original structure 1:1:

```abap
)->a( n = `state` v = `{ path: 'WEIGHT', formatter: 'z2ui5.fmt.weightState' }`
```

Notes on scope:

- Registration is an explicit act of the ABAP app (same trust model as the
  existing `CUSTOM_JS` follow-up actions and the registered-custom-JS `z2ui5`
  action - the server is trusted, this adds no new surface).
- Under a strict CSP without `unsafe-eval` the registry degrades exactly like
  custom-JS Format A does today: log + no-op. Worth stating in the docs.
- A `groupHeaderFactory`/factory variant (functions returning controls) could
  build on the same registry later; the formatter case alone already covers
  the most common demo kit pattern.

## Workaround today

Preformat in ABAP and bind the result (extra model field, value frozen per
round-trip), or unroll rows statically; both documented as deviations
(CAPABILITIES.md "Custom JS formatter functions" ❌).
