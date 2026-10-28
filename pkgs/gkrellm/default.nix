{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  which,
  gtk2,
  glib,
  libX11,
  libSM,
  libICE,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gkrellm";
  version = "2.3.11";

  src = fetchurl {
    url = "http://gkrellm.srcbox.net/releases/gkrellm-${finalAttrs.version}.tar.bz2";
    hash = "sha256-HuBkPtntmfiMFQTInZzLIHgM8pMZyQS2joCo58hnjAY=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    which
  ];

  buildInputs = [
    gtk2
    glib
    libX11
    libSM
    libICE
    openssl
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Stacked single process system monitor";
    homepage = "http://gkrellm.srcbox.net/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gkrellm";
  };
})
