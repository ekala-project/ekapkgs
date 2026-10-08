{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mindwalk";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "mindwalk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CZ+E66X/sfytCmqYD96iNesLZYmbWZ/u9V6pDiljxaA=";
  };

  vendorHash = "sha256-qVoj03LNLbdoCUAOydK7oEHsuZ1BZ6Z2jwYB3gPOfrw=";

  # The pre-built web UI is committed at the tag under internal/server/static,
  # so no npm build is needed.
  subPackages = [ "cmd/mindwalk" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Visualization tool that replays coding-agent sessions on a 3D map of your codebase";
    homepage = "https://github.com/cosmtrek/mindwalk";
    changelog = "https://github.com/cosmtrek/mindwalk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mindwalk";
    platforms = lib.platforms.unix;
  };
})
