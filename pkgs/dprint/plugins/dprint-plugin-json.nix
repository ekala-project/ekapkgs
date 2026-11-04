{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-json";
  version = "0.21.1";

  description = "JSON/JSONC code formatter";

  hash = "sha256-CetVbLXlgZcrBs6yxFNqkK4DK4TThL7qiDfJkYhFTN8=";

  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";

  url = "https://plugins.dprint.dev/json-0.21.1.wasm";
}
