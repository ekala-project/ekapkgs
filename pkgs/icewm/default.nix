{
  lib,
  gccStdenv,
  fetchFromGitHub,
  cmake,
  expat,
  flac,
  fontconfig,
  freetype,
  fribidi,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  gettext,
  giflib,
  glib,
  imlib2,
  libice,
  libsm,
  libx11,
  libxcomposite,
  libxdamage,
  libxdmcp,
  libxext,
  libxfixes,
  libxft,
  libxinerama,
  libxpm,
  libxrandr,
  libjpeg,
  libogg,
  libpng,
  libpthread-stubs,
  libsndfile,
  libtiff,
  libxcb,
  libxcursor,
  mkfontscale,
  pcre2,
  perl,
  pkg-config,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "icewm";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "ice-wm";
    repo = "icewm";
    tag = finalAttrs.version;
    hash = "sha256-RIT425SmLcNb9+va/DrMiU21Gq/gb/obCsd3mEEiXjU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    perl
    pkg-config
    gettext
  ];

  buildInputs = [
    expat
    flac
    fontconfig
    freetype
    fribidi
    gdk-pixbuf
    gdk-pixbuf-xlib
    gettext
    giflib
    glib
    imlib2
    libice
    libsm
    libx11
    libxcomposite
    libxdamage
    libxdmcp
    libxext
    libxfixes
    libxft
    libxinerama
    libxpm
    libxrandr
    libjpeg
    libogg
    libpng
    libpthread-stubs
    libsndfile
    libtiff
    libxcb
    libxcursor
    mkfontscale
    pcre2
  ];

  cmakeFlags = [
    "-DPREFIX=$out"
    "-DCFGDIR=/etc/icewm"
  ];

  # install legacy themes
  postInstall = ''
    cp -r ../lib/themes/{gtk2,Natural,nice,nice2,warp3,warp4,yellowmotif} \
      $out/share/icewm/themes/
  '';

  meta = {
    homepage = "https://ice-wm.org/";
    changelog = "https://github.com/ice-wm/icewm/releases/tag/${finalAttrs.src.tag}";
    description = "Simple, lightweight X window manager";
    license = lib.licenses.lgpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
