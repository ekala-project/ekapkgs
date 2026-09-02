{
  asciidoctor,
  dbus,
  docbook_xml_dtd_45,
  docbook_xsl,
  fetchFromGitHub,
  lib,
  libconfig,
  libdrm,
  libev,
  libGL,
  libepoxy,
  libx11,
  libxcb,
  libxcb-renderutil,
  libxcb-image,
  libxdg_basedir,
  libxext,
  libxml2,
  libxslt,
  makeWrapper,
  meson,
  ninja,
  pcre2,
  pixman,
  pkg-config,
  stdenv,
  uthash,
  xcbutil,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picom";
  version = "12.5";

  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H8IbzzrzF1c63MXbw5mqoll3H+vgcSVpijrlSDNkc+o=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    libconfig
    libdrm
    libev
    libGL
    libepoxy
    libx11
    libxcb
    libxcb-image
    libxcb-renderutil
    libxdg_basedir
    libxext
    libxml2
    libxslt
    pcre2
    pixman
    uthash
    xcbutil
    xorgproto
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Dwith_docs=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Fork of XCompMgr, a sample compositing manager for X servers";
    license = lib.licenses.mit;
    homepage = "https://github.com/yshui/picom";
    mainProgram = "picom";
    platforms = lib.platforms.linux;
  };
})
