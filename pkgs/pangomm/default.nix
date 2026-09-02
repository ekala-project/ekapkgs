{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm,
  cairomm,
}:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version = "2.46.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-uSAWZhUmQk3kuTd/FRL1l4H0H7FsnAJn1hM7oc1o2yI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  propagatedBuildInputs = [
    pango
    glibmm
    cairomm
  ];

  doCheck = true;

  meta = {
    description = "C++ interface to the Pango text rendering library";
    homepage = "https://www.pango.org/";
    license = with lib.licenses; [
      lgpl2
      lgpl21
    ];
    platforms = lib.platforms.unix;
  };
}
