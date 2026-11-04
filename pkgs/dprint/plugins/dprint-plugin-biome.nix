{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-biome";
  version = "0.13.0";

  description = "Biome (JS/TS/JSON) wrapper plugin";

  hash = "sha256-HX4IOjLOGiqacEPdoaGy6QWq7Va1SEOk0J7+U5Rz2QM=";

  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "biome";
    fileExtensions = [
      "ts"
      "tsx"
      "js"
      "jsx"
      "cjs"
      "mjs"
      "json"
    ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/biome/latest.json";

  url = "https://plugins.dprint.dev/biome-0.13.0.wasm";
}
