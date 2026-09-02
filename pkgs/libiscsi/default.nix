{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libiscsi";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = version;
    sha256 = "sha256-idiK9JowKhGAk5F5qJ57X14Q2Y0TbIKRI02onzLPkas=";
  };

  postPatch = ''
    substituteInPlace lib/socket.c \
      --replace-fail "void iscsi_decrement_iface_rr() {" "void iscsi_decrement_iface_rr(void) {"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  env = lib.optionalAttrs (stdenv.hostPlatform.is32bit || stdenv.hostPlatform.isDarwin) {
    NIX_CFLAGS_COMPILE = "-Wno-error=format";
  };

  meta = {
    description = "iscsi client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
