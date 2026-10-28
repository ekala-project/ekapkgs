{
  lib,
  stdenv,
  fetchFromGitHub,
  tcl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcltls";
  version = "1.7.22";

  src = fetchFromGitHub {
    owner = "tcltls";
    repo = "tcltls";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ tcl ];

  buildInputs = [
    tcl
    openssl
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-ssl-dir=${openssl.dev}"
  ];

  meta = {
    description = "TLS extension for Tcl";
    homepage = "https://github.com/tcltls/tcltls";
    license = lib.licenses.tcl;
    platforms = lib.platforms.unix;
  };
})
