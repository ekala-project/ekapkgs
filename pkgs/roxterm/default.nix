{
  at-spi2-core,
  cmake,
  dbus,
  dbus-glib,
  docbook_xsl,
  fetchFromGitHub,
  glib,
  gtk3,
  harfbuzz,
  lib,
  libxdmcp,
  libxtst,
  libepoxy,
  libpthread-stubs,
  libselinux,
  libsepol,
  libtasn1,
  libxkbcommon,
  libxslt,
  p11-kit,
  pcre2,
  pkg-config,
  stdenv,
  util-linuxMinimal,
  vte,
  xmlto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "roxterm";
  version = "3.18.2";

  src = fetchFromGitHub {
    owner = "realh";
    repo = "roxterm";
    rev = finalAttrs.version;
    hash = "sha256-6izxSEGPu3svO3uRb2oPUm1Mcky9EogIrnadt6czyEk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    docbook_xsl
    libxslt
    pkg-config
    gtk3.wrapGAppsHook
    xmlto
  ];

  buildInputs = [
    at-spi2-core
    dbus
    dbus-glib
    glib
    gtk3
    harfbuzz
    libxdmcp
    libxtst
    libepoxy
    libpthread-stubs
    libselinux
    libsepol
    libtasn1
    libxkbcommon
    p11-kit
    pcre2
    util-linuxMinimal
    vte
  ];

  meta = {
    homepage = "https://github.com/realh/roxterm";
    description = "Highly configurable terminal emulator";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "roxterm";
    platforms = lib.platforms.linux;
  };
})
