{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmikmod";
  version = "3.3.14";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/libmikmod-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-3/2CuPJUw0icMgmNqDHzPqxxNoQ9HnzLgC8SVK1bQhk=";
  };

  buildInputs = [ texinfo ] ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-lasound";
  };

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin/libmikmod-config "$dev"
  '';

  meta = {
    description = "Library for playing tracker music module files";
    mainProgram = "libmikmod-config";
    homepage = "https://mikmod.shlomifish.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
