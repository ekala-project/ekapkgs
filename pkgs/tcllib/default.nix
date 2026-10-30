{
  lib,
  stdenv,
  fetchurl,
  tcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcllib";
  version = "1.21";

  src = fetchurl {
    url = "mirror://sourceforge/tcllib/tcllib-${finalAttrs.version}.tar.xz";
    hash = "sha256-EMd0njD91gkiUZMOihqiibGTo7fxq/F/7h1PqJgUdi8=";
  };

  nativeBuildInputs = [ tcl ];

  buildInputs = [ tcl ];

  configureFlags = [
    "--exec-prefix=$(out)"
  ];

  meta = {
    description = "Tcl Standard Library";
    homepage = "https://core.tcl-lang.org/tcllib/";
    license = lib.licenses.tcl;
    platforms = lib.platforms.unix;
  };
})
