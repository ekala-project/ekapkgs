#!/usr/bin/env python3
"""Generate static HTML documentation from ekaos options.json."""

import json
import html
import sys
import os
from collections import defaultdict

def load_options(path):
    with open(path) as f:
        return json.load(f)

def escape(text):
    return html.escape(str(text)) if text else ""

def render_value(val):
    if val is None:
        return ""
    if isinstance(val, dict):
        if val.get("_type") == "literalExpression":
            return f'<code>{escape(val["text"])}</code>'
        if val.get("_type") == "literalMD":
            return escape(val.get("text", ""))
        return f"<code>{escape(json.dumps(val))}</code>"
    if isinstance(val, bool):
        return f"<code>{str(val).lower()}</code>"
    if isinstance(val, (int, float)):
        return f"<code>{val}</code>"
    return f"<code>{escape(val)}</code>"

def render_type(opt):
    return escape(opt.get("type", "unspecified"))

def render_declarations(decls):
    parts = []
    for d in decls:
        if isinstance(d, dict):
            name = d.get("name", "")
            url = d.get("url", "")
            if url:
                parts.append(f'<a href="{escape(url)}">{escape(name)}</a>')
            else:
                parts.append(escape(name))
        else:
            parts.append(escape(str(d)))
    return ", ".join(parts) if parts else ""

def group_options(options):
    groups = defaultdict(dict)
    for name, opt in sorted(options.items()):
        parts = name.split(".")
        if len(parts) >= 2:
            group = f"{parts[0]}.{parts[1]}"
        else:
            group = parts[0]
        groups[group][name] = opt
    return dict(sorted(groups.items()))

CSS = """\
:root {
  --bg: #fff;
  --fg: #24292f;
  --border: #d0d7de;
  --accent: #0969da;
  --code-bg: #f6f8fa;
  --sidebar-bg: #f6f8fa;
  --hover: #f3f4f6;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #0d1117;
    --fg: #e6edf3;
    --border: #30363d;
    --accent: #58a6ff;
    --code-bg: #161b22;
    --sidebar-bg: #161b22;
    --hover: #1c2128;
  }
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
  color: var(--fg);
  background: var(--bg);
  line-height: 1.6;
}
a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }
code {
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  font-size: 0.85em;
  background: var(--code-bg);
  padding: 0.15em 0.4em;
  border-radius: 4px;
}
.layout {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  width: 280px;
  flex-shrink: 0;
  background: var(--sidebar-bg);
  border-right: 1px solid var(--border);
  padding: 1.5rem 1rem;
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}
.sidebar h1 {
  font-size: 1.1rem;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid var(--border);
}
.sidebar ul { list-style: none; }
.sidebar li { margin: 0.15rem 0; }
.sidebar a {
  display: block;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-size: 0.9rem;
}
.sidebar a:hover { background: var(--hover); text-decoration: none; }
.sidebar a.active { font-weight: 600; background: var(--hover); }
.content {
  flex: 1;
  padding: 2rem 3rem;
  max-width: 960px;
}
.content h1 { font-size: 1.8rem; margin-bottom: 0.5rem; }
.content h2 {
  font-size: 1.3rem;
  margin-top: 2rem;
  margin-bottom: 0.5rem;
  padding-bottom: 0.3rem;
  border-bottom: 1px solid var(--border);
}
.option {
  margin: 1.2rem 0;
  padding: 1rem;
  border: 1px solid var(--border);
  border-radius: 6px;
}
.option-name {
  font-weight: 600;
  font-size: 1rem;
  font-family: 'SFMono-Regular', Consolas, monospace;
  color: var(--accent);
}
.option-meta {
  margin-top: 0.4rem;
  font-size: 0.85rem;
  color: #656d76;
}
.option-meta dt { font-weight: 600; display: inline; }
.option-meta dt::after { content: ': '; }
.option-meta dd { display: inline; margin-right: 1.5rem; }
.option-desc { margin-top: 0.5rem; }
.stats { color: #656d76; font-size: 0.9rem; margin-bottom: 1.5rem; }
"""

def render_page(title, sidebar_html, content_html):
    return f"""\
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{escape(title)} — EkaOS Options</title>
  <style>{CSS}</style>
</head>
<body>
<div class="layout">
  <nav class="sidebar">
    <h1>EkaOS Options</h1>
    {sidebar_html}
  </nav>
  <main class="content">
    {content_html}
  </main>
</div>
</body>
</html>
"""

def build_sidebar(groups, active=None):
    items = []
    for group in groups:
        cls = ' class="active"' if group == active else ""
        slug = group.replace(".", "-")
        items.append(f'<li><a href="{slug}.html"{cls}>{escape(group)}</a></li>')
    return f'<ul><li><a href="index.html"{"" if active else " class=\"active\""}>Overview</a></li>{"".join(items)}</ul>'

def build_index(options, groups, sidebar_html):
    total = len(options)
    n_groups = len(groups)
    rows = []
    for group, opts in groups.items():
        slug = group.replace(".", "-")
        rows.append(f'<li><a href="{slug}.html"><code>{escape(group)}</code></a> ({len(opts)} options)</li>')
    content = f"""\
<h1>EkaOS Module Options</h1>
<p class="stats">{total} options across {n_groups} modules</p>
<h2>Modules</h2>
<ul>{"".join(rows)}</ul>
"""
    return render_page("Overview", sidebar_html, content)

def build_group_page(group, opts, sidebar_html):
    items = []
    for name, opt in sorted(opts.items()):
        desc = opt.get("description", "")
        default = render_value(opt.get("default"))
        example = render_value(opt.get("example"))
        typ = render_type(opt)
        decls = render_declarations(opt.get("declarations", []))

        meta_parts = [f"<dt>Type</dt><dd>{typ}</dd>"]
        if default:
            meta_parts.append(f"<dt>Default</dt><dd>{default}</dd>")
        if example:
            meta_parts.append(f"<dt>Example</dt><dd>{example}</dd>")
        if decls:
            meta_parts.append(f"<dt>Declared in</dt><dd>{decls}</dd>")

        items.append(f"""\
<div class="option" id="{escape(name)}">
  <div class="option-name">{escape(name)}</div>
  <dl class="option-meta">{"".join(meta_parts)}</dl>
  <div class="option-desc">{escape(desc)}</div>
</div>""")

    content = f"""\
<h1><code>{escape(group)}</code></h1>
<p class="stats">{len(opts)} options</p>
{"".join(items)}
"""
    return render_page(group, sidebar_html, content)

def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <options.json> <output-dir>", file=sys.stderr)
        sys.exit(1)

    options_path = sys.argv[1]
    output_dir = sys.argv[2]
    os.makedirs(output_dir, exist_ok=True)

    options = load_options(options_path)
    groups = group_options(options)
    sidebar_html = build_sidebar(groups)

    # Write index
    with open(os.path.join(output_dir, "index.html"), "w") as f:
        f.write(build_index(options, groups, build_sidebar(groups)))

    # Write per-group pages
    for group, opts in groups.items():
        slug = group.replace(".", "-")
        with open(os.path.join(output_dir, f"{slug}.html"), "w") as f:
            f.write(build_group_page(group, opts, build_sidebar(groups, active=group)))

    print(f"Generated {len(groups) + 1} pages in {output_dir}/")

if __name__ == "__main__":
    main()
