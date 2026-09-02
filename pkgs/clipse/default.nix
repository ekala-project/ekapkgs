{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "clipse";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iDMHEhYuxspBYG54WivnVj2GfMxAc5dcrjNxtAMhsck=";
  };

  vendorHash = "sha256-LxwST4Zjxq6Fwc47VeOdv19J3g/DHZ7Fywp2ZvVR06I=";

  tags = [ "wayland" ];

  env = {
    CGO_ENABLED = "0";
  };

  proxyVendor = true;

  doCheck = false;

  meta = {
    changelog = "https://github.com/savedra1/clipse/blob/main/CHANGELOG.md";
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
  };
})
