{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  libgit2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cocogitto";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "cocogitto";
    repo = "cocogitto";
    tag = finalAttrs.version;
    hash = "sha256-Z+SXB6bDxyR+Bt3Pz6uF9+sZLjbiFNYeECVFZbx40h8=";
  };

  cargoHash = "sha256-TGcgiXLgxeOO44eNfd9F0VonTTJhOn1iEJwrO65wcxk=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libgit2 ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)
  '';

  meta = {
    changelog = "https://github.com/cocogitto/cocogitto/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Set of cli tools for the conventional commit and semver specifications";
    mainProgram = "cog";
    homepage = "https://docs.cocogitto.io/";
    license = lib.licenses.mit;
  };
})
