{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-http,
  aws-c-io,
  aws-c-sdkutils,
  cmake,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-auth";
  # nixpkgs-update: no auto update
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ac5wAq7T9Xc2oegeC1aUWitb99E6ou1ueyQdIKTkjXk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    s2n-tls
  ];

  propagatedBuildInputs = [
    aws-c-sdkutils
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 library implementation of AWS client-side authentication";
    homepage = "https://github.com/awslabs/aws-c-auth";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
