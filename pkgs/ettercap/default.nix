{
  lib,
  stdenv,
  at-spi2-core,
  bison,
  cmake,
  curl,
  fetchFromGitHub,
  flex,
  geoip,
  glib,
  gtk3,
  harfbuzz,
  libmaxminddb,
  libnet,
  libpcap,
  ncurses,
  openssl,
  pango,
  pcre2,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ettercap";
  version = "0.8.5.2";

  src = fetchFromGitHub {
    owner = "Ettercap";
    repo = "ettercap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TebkIBTiyta2aZ8ZPxYW4367aAOHZxtVVb4pjP6aqPA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    cmake.configurePhaseHook
    flex
    pkg-config
  ];

  buildInputs = [
    at-spi2-core
    curl
    geoip
    glib
    gtk3
    harfbuzz
    libmaxminddb
    libnet
    libpcap
    ncurses
    openssl
    pango
    pcre2
    zlib
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail /etc \$\{INSTALL_PREFIX\}/etc \
      --replace-fail /usr \$\{INSTALL_PREFIX\}
  '';

  cmakeFlags = [
    "-DBUNDLED_LIBS=Off"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${harfbuzz.dev}/include/harfbuzz" ];

  meta = {
    description = "Comprehensive suite for man in the middle attacks";
    homepage = "https://www.ettercap-project.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
