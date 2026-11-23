{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libusb1,
}:

buildGoModule (finalAttrs: {
  pname = "wally-cli";
  version = "2.0.1-osx";

  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally-cli";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-8CJreOB+I07oj9dnJIKNnyoekcBy9tmo5qBwYq3qY4E=";
  };

  vendorHash = "sha256-m2QuNd0/cfAdFdVzctG+E7t/OsslcufXyh6HX2i1KKg=";

  meta = {
    description = "Tool to flash firmware to mechanical keyboards";
    mainProgram = "wally-cli";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.mit;
  };
})
