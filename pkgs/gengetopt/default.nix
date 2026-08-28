{
  fetchurl,
  lib,
  stdenv,
  texinfo,
  help2man,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gengetopt";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/gengetopt/gengetopt-${finalAttrs.version}.tar.xz";
    sha256 = "1b44fn0apsgawyqa4alx2qj5hls334mhbszxsy6rfr0q074swhdr";
  };

  doCheck = true;
  preCheck = ''
    rm tests/test_conf_parser_save.sh
  '';

  enableParallelBuilding = false;

  nativeBuildInputs = [
    texinfo
    help2man
  ];

  postPatch = ''
    substituteInPlace configure --replace \
      'set -o posix' \
      'set +o posix'
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = "-std=c++14";
  };

  meta = {
    description = "Command-line option parser generator";
    mainProgram = "gengetopt";
    homepage = "https://www.gnu.org/software/gengetopt/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
