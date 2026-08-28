{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "vim-startuptime";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "vim-startuptime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d6AXTWTUawkBCXCvMs3C937qoRUZmy0qCFdSLcWh0BE=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/rhysd/vim-startuptime";
    description = "Small Go program for better vim --startuptime alternative";
    license = lib.licenses.mit;
    mainProgram = "vim-startuptime";
  };
})
