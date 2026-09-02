{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enscript";
  version = "1.6.6";

  src = fetchurl {
    url = "mirror://gnu/enscript/enscript-${finalAttrs.version}.tar.gz";
    sha256 = "1fy0ymvzrrvs889zanxcaxjfcxarm2d3k43c9frmbl1ld7dblmkd";
  };

  patches = [
    ./0001-use-system-getopt.patch
    (fetchpatch2 {
      url = "https://salsa.debian.org/debian/enscript/-/raw/7a51479540a210dee5eee4ece5b54e3ce15dec52/debian/patches/1096582-gcc-15";
      hash = "sha256-0H8FNCKgQ1YCwcBaMChQSuFaYlmzSsoqtfsNSr567+Y=";
    })
  ];

  postPatch = ''
    rm compat/getopt.h
    substituteInPlace compat/regex.c --replace \
       __private_extern__  '__attribute__ ((visibility ("hidden")))'
  '';

  buildInputs = [ gettext ];

  doCheck = true;

  meta = {
    description = "Converter from ASCII to PostScript, HTML, or RTF";
    homepage = "https://www.gnu.org/software/enscript/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "enscript";
  };
})
