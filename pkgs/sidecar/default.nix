{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sidecar";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "sidecar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0c3ZDVtGGeCkC1+ileY576JLM2O8TE2ZQnydjGpbeI=";
  };

  vendorHash = "sha256-85CNMeHv95fIkpBS6WHLCqdNSZUr6Qg3jgE/DGX4Jqc=";

  subPackages = [ "cmd/sidecar" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Terminal-based development companion for AI coding agents";
    homepage = "https://github.com/marcus/sidecar";
    changelog = "https://github.com/marcus/sidecar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sidecar";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
