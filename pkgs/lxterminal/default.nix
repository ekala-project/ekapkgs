{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  gtk3,
  vte,
  wrapGAppsHook3,
  libxslt,
  docbook_xml_dtd_412,
  docbook_xsl,
  libxml2,
  findXMLCatalogs,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxterminal";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxterminal";
    tag = finalAttrs.version;
    hash = "sha256-oDWh0U4QWJ84hTfq1oaAmDJM+IY0eJqOUey0qBgZN5U=";
  };

  configureFlags = [
    "--enable-man"
    "--enable-gtk3"
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook3
    libxslt
    docbook_xml_dtd_412
    docbook_xsl
    libxml2
    findXMLCatalogs
  ];

  buildInputs = [
    gtk3
    vte
    pcre2
  ];

  patches = [
    ./respect-xml-catalog-files-var.patch
  ];

  doCheck = true;

  meta = {
    description = "Standard terminal emulator of LXDE";
    homepage = "https://www.lxde.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "lxterminal";
  };
})
