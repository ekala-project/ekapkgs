{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsigsegv";
  version = "2.15";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/libsigsegv-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-A2hVZgIlyzgXoZD8AOZ2TOeDYFG6y0jTXiZES4wXKdk=";
  };

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/libsigsegv/";
    description = "Library to handle page faults in user mode";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
