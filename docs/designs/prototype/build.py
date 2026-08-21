#!/usr/bin/env python3
"""Bundle the prototype into a single self-contained HTML file.

The multi-file source under prototype/ is the readable reference; this
produces dist/pockito-prototype.html which runs from file:// or anywhere.

The build asserts what it produced rather than trusting the substitutions:
a silently-empty stylesheet or a missing icon sprite is a broken deliverable
that still opens, which is the worst way to find out.
"""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).parent
OUT = ROOT / "dist" / "pockito-prototype.html"

CSS_FILES = ("tokens.css", "app.css")
JS_FILES = ("data.js", "domain.js", "ui.js",
            "screens-core.js", "screens-shared.js", "screens-manage.js", "app.js")


def read(p):
    f = ROOT / p
    if not f.exists():
        sys.exit("missing source file: %s" % p)
    text = f.read_text(encoding="utf-8")
    if not text.strip():
        sys.exit("source file is empty: %s" % p)
    return text


css = "\n".join(read("css/" + f) for f in CSS_FILES)
js = "\n".join(read("js/" + f) for f in JS_FILES)
sprite = read("icons.svg")
html = read("index.html")

# strip the dev <head> links, the dev-only block and the per-file script tags
html = re.sub(r'<link rel="stylesheet"[^>]*>\s*', "", html)
html = re.sub(r"<!-- dev-only:start.*?dev-only:end -->\s*", "", html, flags=re.S)
html = re.sub(r'<script src="js/[^"]*"></script>\s*', "", html)

# inline sprite, css and js
html = html.replace('<div id="sprite" hidden></div>', sprite)
html = html.replace("</head>", "<style>\n%s\n</style>\n</head>" % css)
html = html.replace("</body>", "<script>\n%s\n</script>\n</body>" % js)

problems = []
if "<symbol id=\"i-home\"" not in html:
    problems.append("icon sprite was not inlined")
if ".pk-icon{" not in html:
    problems.append("stylesheet was not inlined")
if "window.Domain" not in html or "window.UI" not in html:
    problems.append("scripts were not inlined")
if 'src="js/' in html or 'href="css/' in html:
    problems.append("a reference to an external file survived")
if "dev-only" in html:
    problems.append("the dev-only block survived")
if problems:
    sys.exit("build failed:\n  - " + "\n  - ".join(problems))

OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text(html, encoding="utf-8")
print("built %s  (%.0f KB)" % (OUT.relative_to(ROOT.parent), len(html.encode()) / 1024))
