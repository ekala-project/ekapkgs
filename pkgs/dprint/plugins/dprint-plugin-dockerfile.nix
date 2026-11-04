{ mkDprintPlugin }:
mkDprintPlugin {
  pname = "dprint-plugin-dockerfile";
  version = "0.3.3";

  description = "Dockerfile code formatter";

  hash = "sha256-GaK1sYdZPwQWJmz2ULcsGpWDiKjgPhqNRoGgQfGOkqc=";

  initConfig = {
    configExcludes = [ ];
    configKey = "dockerfile";
    fileExtensions = [ "dockerfile" ];
  };

  updateUrl = "https://plugins.dprint.dev/dprint/dockerfile/latest.json";

  url = "https://plugins.dprint.dev/dockerfile-0.3.3.wasm";
}
