{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libvorbis,
  libmad,
  libao,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrdao";
  version = "1.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/cdrdao/cdrdao-${finalAttrs.version}.tar.bz2";
    hash = "sha256-DPKeEYP/2OTRZ8QD16bqIQmi3UzZfmH4BBfPE3MiD/Q=";
  };

  makeFlags = [
    "RM=rm"
    "LN=ln"
    "MV=mv"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libvorbis
    libmad
    libao
  ];

  hardeningDisable = [ "format" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/cdrdao/cdrdao/commit/105d72a61f510e3c47626476f9bbc9516f824ede.patch";
      hash = "sha256-NVIw59CSrc/HcslhfbYQNK/qSmD4QbfuV8hWYhWelX4=";
    })
  ];

  postPatch = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = "https://cdrdao.sourceforge.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
