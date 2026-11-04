{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "g-plane-markup_fmt";
  version = "0.25.3";

  description = "HTML, Vue, Svelte, Astro, Angular, Jinja, Twig, Nunjucks, and Vento formatter";

  hash = "sha256-bw7cMRYmqzWYqkp7RjT+HtL5jO6+GW9h/yOGQmw+bbU=";

  initConfig = {
    configExcludes = [ ];
    configKey = "markup";
    fileExtensions = [
      "html"
      "vue"
      "svelte"
      "astro"
      "jinja"
      "jinja2"
      "twig"
      "njk"
      "vto"
    ];
  };

  updateUrl = "https://plugins.dprint.dev/g-plane/markup_fmt/latest.json";

  url = "https://plugins.dprint.dev/g-plane/markup_fmt-v0.25.3.wasm";
}
