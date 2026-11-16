{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cli-proxy-api";
  version = "8.0.75";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3FujIFPmn4s6LAMoftpnqo33gAI6R20q3v/NVLz0YNI=";
  };

  vendorHash = "sha256-GlQG6N6m2AwWn0wtM97LLKAxr2kxQTloCB8NgjUwBh4=";

  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Commit=nixpkgs"
    "-X main.BuildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    mv $out/bin/server $out/bin/cli-proxy-api
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Unified proxy providing OpenAI/Gemini/Claude/Codex-compatible APIs for AI coding CLI tools";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    changelog = "https://github.com/router-for-me/CLIProxyAPI/releases";
    license = lib.licenses.mit;
    mainProgram = "cli-proxy-api";
    platforms = lib.platforms.all;
  };
})
