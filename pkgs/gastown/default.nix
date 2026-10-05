{
  lib,
  buildGoModule,
  fetchFromGitHub,
  beads,
  dolt,
  gitMinimal,
  icu,
  makeWrapper,
  sqlite,
  tmux,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gastown";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "gastownhall";
    repo = "gastown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U3spPM8tKp5aoWy+l1qpRtrfIppkQAPSp1z50FQUv2I=";
  };

  vendorHash = "sha256-PQT/Xq9na3vI8Oy9INBYJf3GsiN5IxAVCxrNLhyIpO8=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ icu ];

  subPackages = [ "cmd/gt" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/steveyegge/gastown/internal/cmd.Version=${finalAttrs.version}"
    "-X=github.com/steveyegge/gastown/internal/cmd.Build=release"
    "-X=github.com/steveyegge/gastown/internal/cmd.BuiltProperly=1"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/gt \
      --prefix PATH : ${
        lib.makeBinPath [
          beads
          dolt
          gitMinimal
          sqlite
          tmux
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Multi-agent workspace manager";
    homepage = "https://github.com/gastownhall/gastown";
    changelog = "https://github.com/gastownhall/gastown/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gt";
    platforms = lib.platforms.unix;
  };
})
