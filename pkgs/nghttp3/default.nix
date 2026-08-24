{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = "nghttp3";
    rev = "v${version}";
    hash = "sha256-mp/9Ak03BHjzrJ7Myf3hkrql3+QLQw8nwqBqIp3aER0=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_STATIC_LIB" false)
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
