{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libuuid,
  libaio,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sanlock";
  version = "3.9.4";

  src = fetchurl {
    url = "https://pagure.io/sanlock/archive/sanlock-${finalAttrs.version}/sanlock-sanlock-${finalAttrs.version}.tar.gz";
    hash = lib.fakeHash;
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libuuid
    libaio
  ];

  preBuild = ''
    cd wdmd
  '';

  makeFlags = [
    "prefix=$(out)"
  ];

  postBuild = ''
    cd ../src
    make prefix=$out
  '';

  postInstall = ''
    cd ../src
    make install prefix=$out DESTDIR=
  '';

  meta = {
    description = "Shared storage lock manager";
    homepage = "https://pagure.io/sanlock";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sanlock";
  };
})
