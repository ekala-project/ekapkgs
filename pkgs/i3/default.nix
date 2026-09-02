{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  meson,
  ninja,
  installShellFiles,
  libxcb,
  xcbutilkeysyms,
  xcbutil,
  libxcb-wm,
  xcbutilxrm,
  libstartup_notification,
  libx11,
  pcre2,
  libev,
  yajl,
  xcb-util-cursor,
  perl,
  pango,
  libxkbcommon,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  findXMLCatalogs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i3";
  version = "4.24";

  src = fetchFromGitHub {
    owner = "i3";
    repo = "i3";
    tag = finalAttrs.version;
    hash = "sha256-2tuhfB/SMN+osCBfZtw/yDPhNNEhBH4Qo6dexpqVWYk=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    installShellFiles
    perl
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
  ];

  mesonFlags = [
    (lib.mesonBool "docs" true)
    (lib.mesonBool "mans" true)
  ];

  buildInputs = [
    libxcb
    xcbutilkeysyms
    xcbutil
    libxcb-wm
    xcbutilxrm
    libxkbcommon
    libstartup_notification
    libx11
    pcre2
    libev
    yajl
    xcb-util-cursor
    perl
    pango
  ];

  postPatch = ''
    patchShebangs .
  '';

  doCheck = false;

  postInstall = ''
    wrapProgram "$out/bin/i3-save-tree" --prefix PERL5LIB ":" "$PERL5LIB"
    for program in $out/bin/i3-sensible-*; do
      sed -i 's/which/command -v/' $program
    done

    installManPage man/*.1
  '';

  separateDebugInfo = true;

  meta = {
    description = "Tiling window manager";
    homepage = "https://i3wm.org";
    mainProgram = "i3";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    longDescription = ''
      A tiling window manager primarily targeted at advanced users and
      developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as
      floating windows. Configured via plain text file. Multi-monitor.
      UTF-8 clean.
    '';
  };
})
