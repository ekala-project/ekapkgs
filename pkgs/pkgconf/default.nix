{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  removeReferencesTo,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkgconf";
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-${finalAttrs.version}.tar.gz";
    hash = "sha256-eXIbrcrRmH3q2cNgnrSHerm1iCHAa9rLgk8siJfBHyo=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    automake
    autoconf
    libtool
    removeReferencesTo
    autoreconfHook
  ];

  enableParallelBuilding = true;

  postFixup = ''
    remove-references-to \
      -t "${placeholder "out"}" \
      "${placeholder "lib"}"/lib/*
    remove-references-to \
      -t "${placeholder "dev"}" \
      "${placeholder "lib"}"/lib/* \
      "${placeholder "out"}"/bin/*
    cp -r ${placeholder "dev"}/share/* ${placeholder "out"}/share/
    rm -rf ${placeholder "dev"}/share
  '';

  meta = {
    homepage = "https://github.com/pkgconf/pkgconf";
    description = "Package compiler and linker metadata toolkit";
    license = lib.licenses.isc;
    mainProgram = "pkgconf";
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
