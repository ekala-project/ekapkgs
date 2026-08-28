{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "sesh";
  version = "2.28.0";
  __structuredAttrs = true;

  nativeBuildInputs = [
    go-mockery
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e9OZ5EX3YVT2TMMh9cb4wNAbXezU0PWqQx7A9x9rxKo=";
  };

  # NOTE: prevent crash when getting vendor deps/hash
  overrideModAttrs = _: {
    preBuild = "";
  };

  preBuild = ''
    mockery
  '';

  vendorHash = "sha256-9IiDp/HaxXQAyNzuVBLiO+oIijBbdKBjssCmj8WV9V4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "sesh";
  };
})
