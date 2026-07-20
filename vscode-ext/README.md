# abap2UI5 Demokit Helper (VS Code Extension)

Eine kleine VS-Code-Extension mit Snippets und Befehlen rund um abap2UI5.
Gedacht zum **privaten Teilen** (du + Freunde) – ganz **ohne Marketplace**.

## Features

- **F9 startet die App** – Steht der Cursor in einer ABAP-Klasse, die
  `z2ui5_if_app` implementiert, öffnet **F9** die App **unten im Panel**
  (neben Terminal/Output) in einem eingebetteten Browser.
  Ist die Klasse *keine* z2ui5-App, verhält sich F9 wie gewohnt
  (Breakpoint umschalten).
- **Command "abap2UI5: Neue App-Vorlage einfügen"** – App-Klassen-Skelett.
- **Command "abap2UI5: Demokit im Browser öffnen"** – öffnet das abap2UI5-Repo.
- **Snippets** (in ABAP-Dateien): `z2ui5app`, `z2ui5button`.

Befehle findest du über die Command Palette (`Ctrl/Cmd + Shift + P`).

## Einrichtung der Launch-URL

Beim ersten F9 wirst du nach der Launch-URL gefragt. `{class}` ist der
Platzhalter für den Klassennamen, z. B.:

```
https://host:44300/sap/bc/z2ui5?app_start={class}&sap-client=100
```

Die URL wird gespeichert und lässt sich jederzeit ändern:
Settings → `abap2ui5.launchUrlTemplate` (oder in `settings.json`).

## Öffnen: Browser vs. Panel (`abap2ui5.openMode`)

- **`external`** (Standard): F9 öffnet die App im normalen Browser. Nutzt deine
  bestehende SAP-Anmeldung/SSO – funktioniert zuverlässig.
- **`panel`**: F9 zeigt die App eingebettet unten im VS-Code-Panel.

> **Warum nicht immer Panel?** Der eingebettete iframe hat **keine** SAP-Session.
> Verlangt der Server eine Anmeldung, erscheint dort **401 Not authorized** (der
> Basic-Auth-Dialog wird in eingebetteten Views unterdrückt). `panel` klappt nur,
> wenn der Aufruf ohne interaktives Login funktioniert – z. B. via SICF-Anonym-Logon
> auf dem `/sap/bc/z2ui5`-Knoten. Für den Normalfall ist `external` richtig.
> (Der Panel-View hat oben zusätzlich einen **"Extern öffnen"**-Button.)

---

## Entwickeln

```bash
cd vscode-ext
npm install
npm run compile      # baut dist/extension.js mit esbuild
```

In VS Code den Ordner `vscode-ext` öffnen und **F5** drücken → es startet ein
zweites VS-Code-Fenster (Extension Development Host) mit geladener Extension.

Während der Entwicklung praktisch: `npm run watch` (baut bei jeder Änderung neu).

---

## Als `.vsix` paketieren (zum Verteilen)

```bash
cd vscode-ext
npm install
npm run vsix         # ruft "vsce package --allow-missing-repository" auf
```

Ergebnis: eine Datei wie `abap2ui5-demokit-0.0.1.vsix`. Diese Datei kannst du
per Mail/Cloud/USB an deine Freunde weitergeben. **Kein Marketplace nötig.**

> `vsce` ist als devDependency enthalten; `npm run vsix` nutzt die lokale Version.
> Alternativ global: `npm install -g @vscode/vsce` und dann `vsce package`.

---

## Installieren (für dich & Freunde)

Aus der `.vsix`-Datei – zwei Wege:

**Über die Oberfläche:**
1. Extensions-Panel öffnen (`Ctrl/Cmd + Shift + X`)
2. Oben auf das `…`-Menü → **Install from VSIX…**
3. Die `.vsix`-Datei auswählen

**Über das Terminal:**
```bash
code --install-extension abap2ui5-demokit-0.0.1.vsix
```

**Update** = neue `.vsix` mit höherer Versionsnummer (`version` in `package.json`
hochzählen) bauen und erneut installieren.

---

## Deinstallieren

Extensions-Panel → Extension suchen → **Uninstall**. Oder:

```bash
code --uninstall-extension abap2ui5-local.abap2ui5-demokit
```
