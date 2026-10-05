{
  lib,
  buildGoModule,
  fetchFromGitHub,
  beads,
  dolt,
  gitMinimal,
  jq,
  lsof,
  makeWrapper,
  procps,
  tmux,
  testers,
  versionCheckHook,
}:

assert lib.versionAtLeast dolt.version "2.1.0";

buildGoModule (finalAttrs: {
  pname = "gascity";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "gastownhall";
    repo = "gascity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cHKj7wvd2DjRXhCXoTqYPGB38yQqKYzZ9FCePdMJE3s=";
  };

  vendorHash = "sha256-1fzO7fhQgUTCdsjrmk0dY4XswdeTYoGrAKMwTEuTGIY=";

  env.CGO_ENABLED = "0";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "cmd/gc" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=nixpkgs"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/gc \
      --prefix PATH : ${
        lib.makeBinPath [
          beads
          dolt
          gitMinimal
          jq
          lsof
          procps
          tmux
          # TODO(corepkgs): add flock (util-linux) to the runtime PATH
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Orchestration-builder SDK for multi-agent coding workflows";
    homepage = "https://github.com/gastownhall/gascity";
    changelog = "https://github.com/gastownhall/gascity/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gc";
    platforms = dolt.meta.platforms;
  };
})
