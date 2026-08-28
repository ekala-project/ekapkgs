{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "desed";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "SoptikHa2";
    repo = "desed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aKkOs8IhnHjoJkXq9ryGn9fN0AmZyVTHbD/Vano+Erw=";
  };

  cargoHash = "sha256-1vNs+viEPqmfA8AtFQaGcQwlLAbIBMHd8uMFmqm60eg=";

  meta = {
    changelog = "https://github.com/SoptikHa2/desed/releases/tag/v${finalAttrs.version}";
    description = "Debugger for Sed: demystify and debug your sed scripts, from comfort of your terminal";
    homepage = "https://github.com/SoptikHa2/desed";
    license = lib.licenses.gpl3Only;
    mainProgram = "desed";
  };
})
