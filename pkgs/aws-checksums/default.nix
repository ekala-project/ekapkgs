{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-common,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-checksums";
  # nixpkgs-update: no auto update
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-checksums";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XGsC4FwEGj9g59kQ3SCku/Q93ZICrqydwB23e1qbMvU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
