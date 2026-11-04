{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-markdown";
  version = "0.20.0";

  description = "Markdown code formatter";

  hash = "sha256-XrTiMkgjHOD8a2N5Ips79+D2SbM36s9Hdk7o/iwGIlc=";

  initConfig = {
    configExcludes = [ ];
    configKey = "markdown";
    fileExtensions = [ "md" ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/markdown/latest.json";

  url = "https://plugins.dprint.dev/markdown-0.20.0.wasm";
}
