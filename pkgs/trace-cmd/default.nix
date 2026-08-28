{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  asciidoc,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_45,
  libxslt,
  libtraceevent,
  libtracefs,
  zstd,
  sourceHighlight,
}:

stdenv.mkDerivation rec {
  pname = "trace-cmd";
  version = "3.3.1";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-v${version}.tar.gz";
    hash = "sha256-kEji3qDqQsSK0tL8Fx2ycSd2lTXBXOHHTvsb6XDNSa8=";
  };

  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' \
       Documentation{,/trace-cmd,/libtracecmd}/Makefile
    patchShebangs check-manpages.sh
  '';

  nativeBuildInputs = [
    asciidoc
    libxslt
    pkg-config
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    sourceHighlight
  ];

  buildInputs = [
    libtraceevent
    libtracefs
    zstd
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
    "devman"
  ];

  MANPAGE_DOCBOOK_XSL = "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  enableParallelBuilding = true;
  makeFlags = [
    "prefix=${placeholder "lib"}"
  ];

  postBuild = ''
    make libs doc -j$NIX_BUILD_CORES
  '';

  installTargets = [
    "install_cmd"
    "install_libs"
    "install_doc"
  ];
  installFlags = [
    "LDCONFIG=false"
    "bindir=${placeholder "out"}/bin"
    "mandir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "pkgconfig_dir=${placeholder "dev"}/lib/pkgconfig"
    "includedir=${placeholder "dev"}/include"
    "BASH_COMPLETE_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    mainProgram = "trace-cmd";
    homepage = "https://www.trace-cmd.org/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
    ];
    platforms = lib.platforms.linux;
  };
}
