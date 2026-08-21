{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  gtk4,
  glib,
  glibmm_2_68,
  cairomm_1_16,
  pangomm_2_48,
  libepoxy,
  makeFontsConf,
  xvfb-run ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkmm";
  version = "4.22.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${lib.versions.majorMinor finalAttrs.version}/gtkmm-${finalAttrs.version}.tar.xz";
    hash = "sha256-LoohtLByX2IOM6ruDNND7RIbUzJ1tjKJZhmxyJ6W3mc=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
    glib # glib-compile-resources
  ];

  buildInputs = [
    libepoxy
  ];

  propagatedBuildInputs = [
    glibmm_2_68
    gtk4
    cairomm_1_16
    pangomm_2_48
  ];

  nativeCheckInputs = lib.optionals (xvfb-run != null) [
    xvfb-run
  ];

  # Tests require fontconfig.
  env.FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ ];
  };

  doCheck = xvfb-run != null;

  checkPhase = lib.optionalString (xvfb-run != null) ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs

    runHook postCheck
  '';

  meta = {
    description = "C++ interface to the GTK graphical user interface library";
    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';
    homepage = "https://gtkmm.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
