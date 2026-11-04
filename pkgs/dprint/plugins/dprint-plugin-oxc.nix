{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-oxc";
  version = "0.2.0";

  description = "Oxc (JS/TS) wrapper plugin";

  hash = "sha256-BctJI87x82s3gpCovPSbGp+PfdBuYRZnXeCWWyFHpRs=";

  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "oxc";
    fileExtensions = [
      "ts"
      "tsx"
      "js"
      "jsx"
      "cjs"
      "mjs"
    ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/oxc/latest.json";

  url = "https://plugins.dprint.dev/oxc-0.2.0.wasm";
}
