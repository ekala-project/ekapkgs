{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cairo,
  harfbuzz,
  libintl,
  libthai,
  fribidi,
  meson,
  ninja,
  glib,
  python3,
  docutils,
  libxft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pango";
  version = "1.57.1";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${lib.versions.majorMinor finalAttrs.version}/pango-${finalAttrs.version}.tar.xz";
    hash = "sha256-5l1tEXCA3Drut9i0s7UY9zg6oubPziMRfGI81iR2TC8=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    glib
    pkg-config
    python3
    docutils
  ];

  buildInputs = [
    fribidi
    libthai
  ];

  propagatedBuildInputs = [
    cairo
    glib
    libintl
    harfbuzz
    libxft
  ];

  mesonBuildType = "release";
  mesonAutoFeatures = "auto";

  mesonFlags = [
    (lib.mesonBool "documentation" false)
    (lib.mesonBool "man-pages" true)
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "xft" true)
  ];

  postPatch = ''
    substituteInPlace docs/meson.build \
      --replace "'gi-docgen', req" "'gi-docgen', native:true, req" || true
  '';

  meta = {
    description = "Library for laying out and rendering of text, with an emphasis on internationalization";
    homepage = "https://www.pango.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
