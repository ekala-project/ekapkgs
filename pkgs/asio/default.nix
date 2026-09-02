{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asio";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-pkSu8XMibmRPMoS3v5hO34oJb077bYc9KWELj3t8D6M=";
  };

  patches = [
    ./boost-1.89.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://think-async.com/Asio";
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
  };
})
