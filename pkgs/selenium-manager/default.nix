{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.53.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-21G0hFMOXSOtkBy640iBed4AviPdmYbii9DroVx23nE=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  cargoHash = "sha256-zAR9g7nZ6BdZLptdEh3DqXcnhpm+5by8Dois1DtAVnA=";

  # TODO: enable tests
  # The test suite depends on a number of browsers and network requests,
  # check the Gentoo package for inspiration

  meta = {
    description = "Browser automation framework and ecosystem";
    homepage = "https://github.com/SeleniumHQ/selenium";
    license = lib.licenses.asl20;
    mainProgram = "selenium-manager";
    platforms = lib.platforms.all;
  };
}
