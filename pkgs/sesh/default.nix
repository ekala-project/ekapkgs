{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "sesh";
  version = "2.32.0";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pHsRKndjE2U+Gl0oKW5d+rRST0jDEp61sXm+tRTiD3w=";
  };

  # NOTE: prevent crash when getting vendor deps/hash
  overrideModAttrs = _: {
    preBuild = "";
  };

  preBuild = ''
    go tool mockery
  '';

  vendorHash = "sha256-7wfg53djcty9R8WGo1H4C2VkGDraTu/n1w5c/62/YTc=";

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
