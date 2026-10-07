{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailspin";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    tag = finalAttrs.version;
    hash = "sha256-RI604v8ImQSgvNUGsnCLe6FuzEMJwE0tNVuFLmJLwvM=";
  };

  cargoHash = "sha256-kcd6rBoonoCKuybVIVtZqt+njHFhVDTjTyF2UURuOSI=";

  versionCheckProgram = "${placeholder "out"}/bin/tspin";
  doInstallCheck = true;

  meta = {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "tspin";
  };
})
