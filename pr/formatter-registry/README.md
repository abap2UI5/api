# App-supplied client-side formatter functions (`z2ui5.fmt.*` registry)

> **Status: implemented upstream (2026-07-18).** `z2ui5_if_client` now
> carries `register_formatter( name js )`; the registrations travel as
> their own `T_FORMATTER` response field (new `ty_t_formatter` in
> `z2ui5_if_core_types`) and the new `app/webapp/core/Formatters.js`
> compiles them BEFORE any view of the same response is created.
> `Component.js` publishes the registry as the `z2ui5.fmt` global,
> mirroring `z2ui5.Util`. Deliberately NOT routed through the follow-up
> custom-JS path (`_runCustomJs`), which runs after render and is
> deprecated. Port 401 was converted in the same change and binds the
> original `weightState` formatter 1:1; CAPABILITIES.md is updated.

## Summary

Demo kit samples routinely bind with **custom JS formatter functions**
(`Formatter.js` modules, `formatter: '.fn'` controller methods,
`groupHeaderFactory`, list-item factories). abap2UI5 had no way for an app to
supply such a function, so CAPABILITIES.md marked the category ❌ and ports had
to preformat values in ABAP - which freezes them to render time and breaks 1:1
bindings that reformat client-side.

## Motivation

Ports in this repo that carried a deviation only because a client-side function
could not be supplied:

- **[Table](https://sdk.openui5.org/entity/sap.m.Table/sample/sap.m.sample.Table)**
  (as appended by `z2ui5_cl_ai_app_401`) - `Formatter.js` `weightState` maps a
  numeric weight to a `State` (`Success/Warning/Error`); the port precomputed
  the state into an extra ABAP column. **Converted** - it now registers the
  original body and keeps the original parts binding.
- **[MultiComboBoxGrouping](https://sdk.openui5.org/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping)**
  (`z2ui5_cl_ai_app_452`) - the custom `groupHeaderFactory '.getGroupHeader'`
  happens to match UI5's default headers, so the port survives; any factory
  that does more would not (factories return controls, not values - out of
  scope here, see Notes).
- Per-row list-item factories (`z2ui5_cl_ai_app_481`) - rows are unrolled
  statically because a factory function cannot be expressed (same "returns
  controls" caveat).

## Implemented design

ABAP side - one method, no new trust surface (the server is trusted, exactly
as it already is for the XML views and models it ships):

```abap
client->register_formatter(
  name = `weightState`
  js   = `(fMeasure, sUnit) => { ... }` ).   " a single function expression
```

- `z2ui5_cl_core_client` appends `name`/`js` to
  `ms_next-s_set-t_formatter`; re-registering a name replaces its entry.
- The generic upper-case ajson mapping serializes it as
  `PARAMS.T_FORMATTER: [{NAME, JS}]` - no bespoke wire code.
- App navigation clears pending registrations together with messages and
  follow-up actions (`z2ui5_cl_core_action`), so nothing leaks into the next
  app.

Client side - `app/webapp/core/Formatters.js`:

- `Server.responseSuccess` calls `Formatters.registerAll(PARAMS.T_FORMATTER)`
  **before** view creation - the timing that makes binding strings resolve;
  the deprecated follow-up custom-JS path runs after render and is not
  involved.
- Each body is compiled once per name+source (`Function`, cached) and stored
  on the `z2ui5.fmt` global. A body that does not compile to a function is
  logged and skipped; under a CSP without `unsafe-eval` every entry degrades
  that way and the binding falls back to its unformatted value.

View usage, 1:1 with the demo kit original:

```abap
)->a( n = `state` v = |\{ parts:[\{path:'WEIGHT_MEASURE'\},\{path:'WEIGHT_UNIT'\}], formatter: 'z2ui5.fmt.weightState' \}|
```

## Notes

- **Scope: value formatters only.** `groupHeaderFactory` and list-item
  factories return *controls*; supporting them would mean building UI5
  elements from registered code and wiring aggregation lifecycles - a
  separate request if a port ever genuinely needs it.
- The render-smoke harness mirrors the contract with an identity-function
  `z2ui5.fmt` proxy, so ports using registered formatters stay smoke-testable
  without executing app JS.
