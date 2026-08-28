{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  which,
  pkg-config,
  intltool,
  file,
  libintl,
  hicolor-icon-theme,
  python3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geany";
  version = "2.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "https://download.geany.org/geany-${finalAttrs.version}.tar.bz2";
    hash = "sha256-VltM0vAxHB46Fn7HHEoy26ZC4P5VSuW7a4F3t6dMzJI=";
  };

  patches = [
    ./disable-test-sidebar.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    libintl
    which
    file
    hicolor-icon-theme
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  preCheck = ''
    patchShebangs --build tests/ctags/runner.sh
    patchShebangs --build scripts
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Small and lightweight IDE";
    homepage = "https://www.geany.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "geany";
  };
})
