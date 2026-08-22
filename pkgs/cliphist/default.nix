{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "cliphist";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "cliphist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y4FSl/Bj80XqCR0ZwjGEkqYUIF6zJHrYyy01XPFlzjU=";
  };

  vendorHash = "sha256-4XyDLOJHdre/1BpjgFt/W6gOlPOvKztE+MsbwE3JAaQ=";

  doCheck = false;

  meta = {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "cliphist";
  };
})
