{
  lib,
  stdenv,
  fetchurl,
  libxt,
  libxft,
  libxext,
  libxaw,
  libx11,
  libsm,
  libice,
  xorgproto,
  ncurses,
  freetype,
  fontconfig,
  pkg-config,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xterm";
  version = "410";

  src = fetchurl {
    urls = [
      "https://invisible-island.net/archives/xterm/xterm-${finalAttrs.version}.tgz"
      "https://invisible-mirror.net/archives/xterm/xterm-${finalAttrs.version}.tgz"
    ];
    hash = "sha256-e6n7swPdPZXQbKJDYNAZBI2E5YItxv5yLNdzab2/Ix8=";
  };

  patches = [ ./sixel-256.support.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    fontconfig
  ];

  buildInputs = [
    libxaw
    xorgproto
    libxt
    libxext
    libx11
    libsm
    libice
    ncurses
    freetype
    libxft
  ];

  configureFlags = [
    "--enable-wide-chars"
    "--enable-256-color"
    "--enable-sixel-graphics"
    "--enable-regis-graphics"
    "--enable-load-vt-fonts"
    "--enable-i18n"
    "--enable-doublechars"
    "--enable-dec-locator"
    "--disable-luit"
    "--with-tty-group=tty"
    "--with-app-defaults=$(out)/lib/X11/app-defaults"
  ];

  env = {
    NIX_LDFLAGS = "-lXmu -lXt -lICE -lX11 -lfontconfig";
  };

  postConfigure = ''
    echo '#define USE_UTMP_SETGID 1'
  '';

  enableParallelBuilding = true;

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram $bin --set XAPPLRESDIR $out/lib/X11/app-defaults/
    done

    install -D -t $out/share/applications xterm.desktop
    install -D -t $out/share/icons/hicolor/48x48/apps icons/xterm-color_48x48.xpm
  '';

  meta = {
    description = "Terminal emulator for the X Window System";
    homepage = "https://invisible-island.net/xterm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "xterm";
  };
})
