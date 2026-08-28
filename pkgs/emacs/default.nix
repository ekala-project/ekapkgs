{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  autoreconfHook,
  gettext,
  gnutls,
  jansson,
  libselinux,
  libxml2,
  mailcap,
  makeWrapper,
  ncurses,
  pkg-config,
  sqlite,
  texinfo,
  zlib,
  acl,
  gpm,
  dbus,
  systemdLibs,
  harfbuzz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emacs-nox";
  version = "30.2";

  src = fetchgit {
    url = "https://https.git.savannah.gnu.org/git/emacs.git";
    rev = "emacs-${finalAttrs.version}";
    hash = "sha256-3Lfb3HqdlXqSnwJfxe7npa4GGR9djldy8bKRpkQCdSA=";
  };

  patches = [
    (fetchpatch {
      name = "fix-off-by-one-mistake-80851-CVE-2026-6861.patch";
      url = "https://cgit.git.savannah.gnu.org/cgit/emacs.git/patch/?id=8f535370b9efbc91673b20c6987a5cae4f6dc562";
      hash = "sha256-ny44eIi8DUa9pQhVGzhGz4H6FXU4+ki86SITLXhkwpw=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
    pkg-config
    texinfo
  ];

  buildInputs = [
    acl
    dbus
    gnutls
    gpm
    (lib.getDev harfbuzz)
    jansson
    libselinux
    libxml2
    ncurses
    sqlite
    systemdLibs
    zlib
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    rm -fr .git

    substituteInPlace src/Makefile.in \
      --replace-warn 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'

    substituteInPlace lisp/international/mule-cmds.el \
      --replace-warn /usr/share/locale ${gettext}/share/locale

    for makefile_in in $(find . -name Makefile.in -print); do
      substituteInPlace $makefile_in --replace-warn /bin/pwd pwd
    done

    substituteInPlace lisp/net/mailcap.el \
      --replace-fail '"/etc/mime.types"' \
                     '"/etc/mime.types" "${mailcap}/etc/mime.types"' \
      --replace-fail '("/etc/mailcap" system)' \
                     '("/etc/mailcap" system) ("${mailcap}/etc/mailcap" system)'
  '';

  configureFlags = [
    "--disable-build-details"
    "--with-modules"
    "--with-x-toolkit=no"
    "--without-xft"
    "--without-x"
    "--without-xpm"
    "--without-jpeg"
    "--without-tiff"
    "--without-gif"
    "--without-png"
    "--without-rsvg"
    "--without-imagemagick"
    "--without-xwidgets"
    "--without-toolkit-scroll-bars"
    "--without-gconf"
    "--without-gsettings"
    "--without-cairo"
    "--without-pgtk"
    "--without-native-compilation"
    "--without-mailutils"
    "--without-tree-sitter"
    "--without-xinput2"
    "--without-webp"
    "--without-small-ja-dic"
    "--with-compress-install"
    "--with-dbus"
    "--with-selinux"
    "--with-json"
  ];

  enableParallelBuilding = true;

  installTargets = [
    "tags"
    "install"
  ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp

    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el || true

    siteVersionDir=$(ls $out/share/emacs | grep -v site-lisp | head -n 1)

    rm -rf $out/share/emacs/$siteVersionDir/site-lisp

    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/$siteVersionDir/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir || true
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '';

  meta = {
    homepage = "https://www.gnu.org/software/emacs/";
    description = "Extensible, customizable GNU text editor (terminal-only)";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "emacs";
  };
})
