{
  lib,
  stdenv,
  fetchurl,
  SDL ? null,
  check,
  curl,
  expat,
  gperf,
  gtk3,
  libxcursor,
  libxrandr,
  libidn,
  libjpeg,
  libjxl,
  libpng,
  libwebp,
  libxml2,
  makeWrapper,
  openssl,
  perlPackages,
  pkg-config,
  wrapGAppsHook3,
  xxd,

  # Netsurf-specific dependencies
  netsurf-buildsystem,
  libcss,
  libdom,
  libhubbub,
  libnsbmp,
  libnsfb ? null,
  libnsgif,
  libnslog,
  libnspsl,
  libnsutils,
  libparserutils,
  libsvgtiny,
  libutf8proc ? null,
  libwapcaplet,
  nsgenbind,

  # Configuration
  uilib ? "gtk3",
}:

assert lib.assertOneOf "uilib" uilib [
  "gtk3"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf";
  version = "3.11";

  src = fetchurl {
    url = "https://download.netsurf-browser.org/netsurf/releases/source/netsurf-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-wopiau/uQo0FOxP4i1xECSIkWXZSLRLq8TfP0y0gHLI=";
  };

  nativeBuildInputs = [
    makeWrapper
    perlPackages.HTMLParser
    perlPackages.perl
    pkg-config
    xxd
    wrapGAppsHook3
  ];

  buildInputs = [
    check
    curl
    gperf
    libxcursor
    libxrandr
    libidn
    libjpeg
    libjxl
    libpng
    libwebp
    libxml2
    openssl
    libcss
    libdom
    libhubbub
    libnsbmp
    libnsgif
    libnslog
    libnspsl
    libnsutils
    libparserutils
    libsvgtiny
    libwapcaplet
    nsgenbind
    gtk3
  ]
  ++ lib.optional (libnsfb != null) libnsfb
  ++ lib.optional (libutf8proc != null) libutf8proc;

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    cat <<EOF > Makefile.config
    override NETSURF_GTK_RES_PATH  := $out/share/
    override NETSURF_USE_GRESOURCE := YES
    EOF
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=${uilib}"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Free, open source, small web browser";
    mainProgram = "netsurf-gtk3";
    longDescription = ''
      NetSurf is a free, open source web browser. It is written in C and
      released under the GNU Public Licence version 2. NetSurf has its own
      layout and rendering engine entirely written from scratch. It is small and
      capable of handling many of the web standards in use today.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
