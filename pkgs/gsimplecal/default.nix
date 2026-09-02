{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsimplecal";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "dmedvinsky";
    repo = "gsimplecal";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OaXZ/ch/Os6oi6V75Sy+QHeIGolwtieecFuLy4998yc=";
  };

  postPatch = ''
    sed -i -e '/sys\/sysctl.h/d' src/Unique.cpp
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];
  buildInputs = [ gtk3 ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://dmedvinsky.github.io/gsimplecal/";
    description = "Lightweight calendar application written in C++ using GTK";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "gsimplecal";
  };
})
