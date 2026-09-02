{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  sqlite,
  libpsl,
  brotli,
  nghttp2,
  python3,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsoup";
  version = "3.6.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libsoup/${lib.versions.majorMinor finalAttrs.version}/libsoup-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ue0K4G+dWkD0Af9Fni5fZS+aUQt3MOE1nuZtFNSHJ0A=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    glib
    python3
  ];

  buildInputs = [
    sqlite
    libpsl
    glib.out
    brotli
    nghttp2.lib
  ];

  propagatedBuildInputs = [
    glib
    glib-networking
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Dtls_check=false"
    "-Dgssapi=disabled"
    "-Dntlm=disabled"
    "-Dautobahn=disabled"
    "-Dpkcs11_tests=disabled"
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "sysprof" false)
    (lib.mesonEnable "vapi" false)
  ];

  env.PKG_CONFIG_PATH = "${nghttp2.dev}/lib/pkgconfig";

  doCheck = false;

  postPatch = ''
    patchShebangs libsoup/
  '';

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libsoup";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
