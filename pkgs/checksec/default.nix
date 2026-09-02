{
  lib,
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module (finalAttrs: {
  pname = "checksec";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec";
    tag = finalAttrs.version;
    hash = "sha256-vvfr5JsCTq1NWUfOOlHIjf+ToNNzP5Xps09XPLlG1zc=";
  };

  vendorHash = "sha256-sW2C39xhMQCyR8S1m0ZplVQxu42w+tNqjxH7VO5stGw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Tool for checking security bits on executables";
    mainProgram = "checksec";
    homepage = "https://slimm609.github.io/checksec/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
