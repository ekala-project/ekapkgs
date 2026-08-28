{
  lib,
  stdenv,
  fetchurl,
  gettext,
  emacs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cflow";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/cflow/cflow-${finalAttrs.version}.tar.bz2";
    hash = "sha256-gyFie1W2x4d/akP8xvn4RqlLFHaggaA1Rl96eNNJmrg=";
  };

  postPatch = ''
    substituteInPlace "config.h.in" \
      --replace-fail "[[__maybe_unused__]]" "__attribute__((__unused__))"
    substituteInPlace "src/cflow.h" \
      --replace-fail "/usr/bin/cpp" "${stdenv.cc.cc}/bin/cpp"
  '';

  buildInputs = [
    gettext
    emacs
  ];

  doCheck = true;

  meta = {
    description = "Tool to analyze the control flow of C programs";
    mainProgram = "cflow";
    homepage = "https://www.gnu.org/software/cflow/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
