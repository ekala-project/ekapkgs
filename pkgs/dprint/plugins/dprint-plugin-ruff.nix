{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-ruff";
  version = "0.6.12";

  description = "Ruff (Python) wrapper plugin";

  hash = "sha256-kKdkIV4QbJZ8njBd8jVhwQsi7I3+PqWT/e3ORqWV7yQ=";

  initConfig = {
    configExcludes = [ ];
    configKey = "ruff";
    fileExtensions = [
      "py"
      "pyi"
    ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/ruff/latest.json";

  url = "https://plugins.dprint.dev/ruff-0.6.12.wasm";
}
