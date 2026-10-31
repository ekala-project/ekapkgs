{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  intltool,
  glib,
  libx11,
  xrandr,
  gtk3,
  autoreconfHook,
  libxslt,
  docbook-xsl,
  docbook_xml_dtd_412,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxrandr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxrandr";
    tag = finalAttrs.version;
    hash = "sha256-EGUnvV1FqQUJkjGwxgVecXOohAu8Qa8Prgk6xZfJBe4=";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  patches = [ ./respect-xml-catalog-files-var.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    libxslt
    libxml2
    docbook_xml_dtd_412
    docbook-xsl
  ];

  buildInputs = [
    glib
    libx11
    xrandr
    gtk3
  ];

  meta = {
    description = "Standard screen manager of LXDE";
    mainProgram = "lxrandr";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
