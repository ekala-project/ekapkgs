{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-toml";
  version = "0.7.0";

  description = "TOML code formatter";

  hash = "sha256-ASbIESaRVC0wtSpjkHbsyD4Hus6HdjjO58aRX9Nrhik=";

  initConfig = {
    configExcludes = [ ];
    configKey = "toml";
    fileExtensions = [ "toml" ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/toml/latest.json";

  url = "https://plugins.dprint.dev/toml-0.7.0.wasm";
}
