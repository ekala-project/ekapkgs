{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "dht";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "dht";
    rev = "015585510e402a057ec17142711ba2b568b5fd62";
    sha256 = "m4utcxqE3Mn5L4IQ9UfuJXj2KkXXnqKBGqh7kHHGMJQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "BitTorrent DHT library";
    homepage = "https://github.com/transmission/dht";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
