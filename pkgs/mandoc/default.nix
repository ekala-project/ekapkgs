{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mandoc";
  version = "1.14.6";

  src = fetchurl {
    url = "https://mandoc.bsd.lv/snapshots/mandoc-${finalAttrs.version}.tar.gz";
    sha256 = "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c";
  };

  buildInputs = [ zlib ];

  configureLocal = ''
    MANPATH_DEFAULT="/run/current-system/sw/share/man"
    MANPATH_BASE="$MANPATH_DEFAULT"
    OSNAME="Nixpkgs"
    PREFIX="$out"
    LD_OHASH="-lutil"
    LN="ln -sf"
    SBINDIR="$PREFIX/bin"
    CC=${stdenv.cc.targetPrefix}cc
    AR=${stdenv.cc.bintools.targetPrefix}ar
    READ_ALLOWED_PATH=${builtins.storeDir}
    HAVE_WCHAR=1
    UTF8_LOCALE=C.UTF-8
  '';

  preConfigure = ''
    printf '%s' "$configureLocal" > configure.local
  '';

  meta = {
    homepage = "https://mandoc.bsd.lv/";
    description = "Suite of tools compiling mdoc and man";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "man";
  };
})
