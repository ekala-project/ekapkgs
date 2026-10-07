{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  sdl2-compat,
}:

stdenv.mkDerivation {
  pname = "smpeg2";
  version = "unstable-2022-05-26";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "smpeg";
    rev = "c5793e5f3f2765fc09c24380d7e92136a0e33d3b";
    sha256 = "sha256-Z0u83K1GIXd0jUYo5ZyWUH2Zt7Hn8z+yr06DAtAEukw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
    pkg-config
  ];

  buildInputs = [ sdl2-compat ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  preConfigure = ''
    sh autogen.sh
  '';

  postInstall = ''
    moveToOutput bin/smpeg2-config "$dev"
    wrapProgram $dev/bin/smpeg2-config \
      --prefix PATH ":" "${pkg-config}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${lib.getDev sdl2-compat}/lib/pkgconfig"
  '';


  meta = {
    homepage = "https://icculus.org/smpeg/";
    description = "sdl2-compat MPEG Player Library";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
