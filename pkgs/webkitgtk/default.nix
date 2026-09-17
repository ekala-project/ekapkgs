{
  lib,
  clangStdenv,
  fetchurl,
  perl,
  python3,
  ruby,
  gi-docgen,
  bison,
  gperf,
  cmake,
  ninja,
  pkg-config,
  gettext,
  gobject-introspection,
  gnutls,
  libgcrypt,
  libgpg-error,
  gtk3 ? null,
  gtk4,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libwebp,
  enchant,
  libx11,
  libxkbcommon,
  libavif,
  libepoxy,
  libjxl,
  at-spi2-core,
  cairo,
  expat,
  libxml2,
  libsoup_3,
  libsecret,
  libxslt,
  harfbuzz,
  hyphen,
  icu,
  libsysprof-capture,
  libpthread-stubs,
  nettle,
  libtasn1,
  p11-kit,
  libidn,
  readline,
  libGL,
  libGLU ? null,
  libgbm,
  lcms2,
  geoclue2,
  flite,
  fontconfig,
  freetype,
  openssl,
  sqlite,
  gst_all_1,
  bubblewrap,
  libseccomp,
  libbacktrace,
  systemd,
  xdg-dbus-proxy,
  replaceVars,
  glib,
  unifdef,
  addDriverRunpath,
  fetchpatch,
  enableGeoLocation ? true,
  enableExperimental ? false,
  withLibsecret ? true,
  withGtk3 ? false,
}:

let
  abiVersion = if withGtk3 then "4.1" else "6.0";
  gtkDep = if withGtk3 then gtk3 else gtk4;
in

clangStdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.52.6";
  name = "webkitgtk-${finalAttrs.version}+abi=${abiVersion}";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  separateDebugInfo = clangStdenv.hostPlatform.isLinux && !clangStdenv.hostPlatform.is32bit;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-F5ouo/j27dS+fzH9xVr8V70HKfH7pkjGHUGBU5rBFvw=";
  };

  patches = lib.optionals clangStdenv.hostPlatform.isLinux [
    (replaceVars ./fix-bubblewrap-paths.patch {
      inherit (builtins) storeDir;
      inherit (addDriverRunpath) driverLink;
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    gettext
    gobject-introspection
    gperf
    ninja
    perl
    perl.pkgs.FileCopyRecursive
    pkg-config
    python3
    ruby
    gi-docgen
    glib
    unifdef
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    at-spi2-core
    cairo
    enchant
    expat
    flite
    freetype
    libavif
    libepoxy
    libjxl
    gnutls
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    harfbuzz
    hyphen
    icu
    libGL
    libgbm
    libgcrypt
    libgpg-error
    libidn
    lcms2
    libpthread-stubs
    libsysprof-capture
    libtasn1
    libwebp
    libxkbcommon
    libxml2
    libxslt
    libbacktrace
    nettle
    p11-kit
    sqlite
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    libseccomp
    wayland
    libx11
  ]
  ++ lib.optionals (clangStdenv.hostPlatform.isLinux && !withGtk3) [
    wayland-protocols
  ]
  ++ lib.optional enableGeoLocation geoclue2
  ++ lib.optional withLibsecret libsecret
  ++ [ systemd ];

  propagatedBuildInputs = [
    gtkDep
    libsoup_3
  ];

  cmakeFlags = [
    "-DENABLE_INTROSPECTION=ON"
    "-DPORT=GTK"
    "-DUSE_LIBSECRET=${if withLibsecret then "ON" else "OFF"}"
    "-DENABLE_EXPERIMENTAL_FEATURES=${if enableExperimental then "ON" else "OFF"}"
    "-DENABLE_GAMEPAD=OFF"
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    "-DBWRAP_EXECUTABLE=${lib.getExe bubblewrap}"
    "-DDBUS_PROXY_EXECUTABLE=${lib.getExe xdg-dbus-proxy}"
  ]
  ++ lib.optionals withGtk3 [
    "-DUSE_GTK4=OFF"
  ];

  postPatch = ''
    patchShebangs .
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Web content rendering engine, GTK port";
    mainProgram = "WebKitWebDriver";
    homepage = "https://webkitgtk.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
