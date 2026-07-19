{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  meson,
  ninja,
  cunit,
}:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.8.4";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
    hash = "sha256-T4NxYVJKl+2YZ6JZ7PvtM4RdTg9DIE+su4KxJwvw7iI=";
  };

  postPatch = ''
    chmod +x Documentation/install-docs.sh.in
    patchShebangs --build check-manpages.sh Documentation/install-docs.sh.in
  '';

  outputs = [
    "out"
    "dev"
    "devman"
    "doc"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
  ];

  ninjaFlags = [
    "all"
    "docs"
  ];

  doCheck = true;
  checkInputs = [ cunit ];

  meta = {
    description = "Linux kernel trace event library";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
