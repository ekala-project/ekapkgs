{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  asciidoc,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_45,
  readline,
  makeWrapper,
  git,
  autoreconfHook,
  findXMLCatalogs,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tig";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "jonas";
    repo = "tig";
    rev = "tig-${finalAttrs.version}";
    sha256 = "sha256-Zfmt2rpnH5sxiay1LAsXxvtvqvwEG4MbNI+p0GWJsMc=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    findXMLCatalogs
    pkg-config
  ];

  autoreconfFlags = [
    "-I"
    "tools"
    "-v"
  ];

  buildInputs = [
    ncurses
    readline
    git
  ];

  postPatch = ''
    rm contrib/config.make-*
  '';

  enableParallelBuilding = true;

  installPhase = ''
    make install
    make install-doc

    sed -i '1s;^;source ${git}/share/bash-completion/completions/git\n;' contrib/tig-completion.bash

    install -D contrib/tig-completion.bash $out/share/bash-completion/completions/tig
    cp contrib/vim.tigrc $out/etc/

    wrapProgram $out/bin/tig \
      --suffix PATH ':' "${git}/bin"
  '';

  outputs = [
    "out"
    "doc"
    "man"
  ];

  meta = {
    homepage = "https://jonas.github.io/tig/";
    description = "Text-mode interface for git";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "tig";
  };
})
