// Generate build/index.html — the static landing gallery for the in-browser
// demo. Pure HTML/CSS, boots NO abap2UI5: the heavy 136-row overview app is
// the one view deep enough to overflow Safari's JS stack, so the front page
// must not render it. Every card links to run.html?app_start=<class>, which
// boots that single port (individual ports render well within the stack).
//
// Reads the per-port sidecars in ../../meta and writes ../build/index.html.
import { readdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const HERE = dirname(fileURLToPath(import.meta.url));
const META = join(HERE, "..", "..", "meta");
const BUILD = join(HERE, "..", "build");
if (!existsSync(BUILD)) throw new Error("build/ not found — run webpack:build first");

const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));

const ports = readdirSync(META)
  .filter((f) => f.endsWith(".json"))
  .map((f) => JSON.parse(readFileSync(join(META, f), "utf8")))
  .filter((m) => /^z2ui5_cl_ai_app_\d+$/.test(m.class || ""))
  .map((m) => {
    const lib = m.sample?.includes(".sample.") ? m.sample.slice(0, m.sample.indexOf(".sample.")) : "sap.m";
    const name = m.sample?.includes(".sample.") ? m.sample.slice(m.sample.indexOf(".sample.") + 8) : m.sample || m.class;
    const num = Number((m.class.match(/(\d+)$/) || [])[1] || 0);
    const control = (m.entity || "").split(".").pop();
    return { class: m.class, lib, name, num, control, entity: m.entity || "" };
  })
  .sort((a, b) => a.num - b.num);

const libs = [...new Set(ports.map((p) => p.lib))].sort();
const sections = libs.map((lib) => {
  const cards = ports.filter((p) => p.lib === lib).map((p) => `
      <a class="card" href="run.html?app_start=${esc(p.class)}">
        <div class="num">#${p.num}</div>
        <div class="name">${esc(p.name)}</div>
        <div class="ctrl">${esc(p.control)}</div>
      </a>`).join("");
  return `
    <section>
      <h2>${esc(lib)} <span class="badge">${ports.filter((p) => p.lib === lib).length}</span></h2>
      <div class="grid">${cards}</div>
    </section>`;
}).join("");

const html = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>abap2UI5 · ai-demokit — ${ports.length} live ports</title>
<link rel="icon" href="data:," />
<style>
  :root { color-scheme: light dark; --bg:#f6f7f9; --fg:#1a1c1e; --muted:#6a7178; --card:#fff; --line:#e3e6ea; --accent:#0a6ed1; }
  @media (prefers-color-scheme: dark) { :root { --bg:#12141a; --fg:#e8eaed; --muted:#9aa0a6; --card:#1b1e26; --line:#2a2e38; --accent:#4aa3ff; } }
  * { box-sizing: border-box; }
  body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif; background:var(--bg); color:var(--fg); line-height:1.4; }
  header { padding:2rem 1.25rem 1rem; max-width:1180px; margin:0 auto; }
  h1 { margin:0 0 .3rem; font-size:1.5rem; }
  .sub { color:var(--muted); font-size:.95rem; }
  .sub a { color:var(--accent); text-decoration:none; }
  main { max-width:1180px; margin:0 auto; padding:0 1.25rem 3rem; }
  section { margin-top:1.75rem; }
  h2 { font-size:1.05rem; margin:0 0 .75rem; display:flex; align-items:center; gap:.5rem; }
  .badge { font-size:.72rem; font-weight:600; color:var(--muted); background:var(--line); border-radius:999px; padding:.1rem .55rem; }
  .grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:.75rem; }
  .card { display:block; text-decoration:none; color:inherit; background:var(--card); border:1px solid var(--line); border-radius:12px; padding:.85rem .9rem; transition:transform .08s ease, border-color .12s ease, box-shadow .12s ease; }
  .card:hover { transform:translateY(-2px); border-color:var(--accent); box-shadow:0 6px 18px rgba(0,0,0,.10); }
  .num { font-size:.72rem; color:var(--muted); font-variant-numeric:tabular-nums; }
  .name { font-weight:600; margin:.15rem 0; word-break:break-word; }
  .ctrl { font-size:.8rem; color:var(--accent); word-break:break-word; }
  footer { max-width:1180px; margin:0 auto; padding:1rem 1.25rem 3rem; color:var(--muted); font-size:.85rem; }
  footer a { color:var(--accent); text-decoration:none; }
</style>
</head>
<body>
<header>
  <h1>abap2UI5 · ai-demokit</h1>
  <div class="sub">${ports.length} UI5 demo-kit samples ported to abap2UI5, running <b>fully in your browser</b> — transpiled ABAP + sql.js WASM, no backend. Pick one to launch it. &nbsp;<a href="https://github.com/abap2UI5/ai-demokit">GitHub</a></div>
</header>
<main>${sections}
</main>
<footer>
  Powered by <a href="https://github.com/abap2UI5/abap2UI5">abap2UI5</a> ·
  in-browser build via <a href="https://github.com/abap2UI5/web-abap2UI5">web-abap2UI5</a> (transpiler / express-icf-shim / webpacking by larshp).
  UI5 loads from the sdk.openui5.org CDN at runtime.
</footer>
</body>
</html>
`;

writeFileSync(join(BUILD, "index.html"), html);
console.log(`gen_landing: wrote build/index.html — ${ports.length} ports, ${libs.length} libraries`);
