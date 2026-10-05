{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  git,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "crit";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "tomasz-tomczyk";
    repo = "crit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EoL719RMvNYLMx6KzkxBTmvrI5pw44YLNWckW+zn414=";
  };

  vendorHash = "sha256-iEeHP8r32ipnAV54dflLKg/XPJXjO1M3KqslRcQnhZ0=";

  subPackages = [ "cmd/crit" ];

  # Story-generation tests exec fake agent scripts via /usr/bin/env, which is
  # absent from the sandbox.
  postPatch = ''
    substituteInPlace cmd/crit/cli_handlers_story_llm_test.go \
      --replace-fail '#!/usr/bin/env bash' '#!${lib.getExe bash}'
  '';

  # Preflight tests shell out to `git init`.
  nativeCheckInputs = [ git ];
  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.email crit@example.com
    git config --global user.name crit
    git config --global init.defaultBranch main
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Local-first review tool for coding-agent plans, diffs, and web pages";
    homepage = "https://github.com/tomasz-tomczyk/crit";
    changelog = "https://github.com/tomasz-tomczyk/crit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "crit";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
