{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  zlib,
}:

stdenv.mkDerivation {
  pname = "libtelnet";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "seanmiddleditch";
    repo = "libtelnet";
    rev = "45f2d5cfcf383312280e61c85b107285fed260cf";
    sha256 = "sha256-ql0XDyDoSXwsJQDv9+ymU8hupxQMIQ8r4uLqZld75tI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [ zlib ];

  meta = {
    description = "Simple RFC-complient TELNET implementation as a C library";
    homepage = "https://github.com/seanmiddleditch/libtelnet";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
  };
}
