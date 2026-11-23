{
  fetchurl,
  lib,
  stdenv,
  perl,
  makeWrapper,
  procps,
  coreutils,
  gawk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parallel";
  version = "20261022";

  src = fetchurl {
    url = "mirror://gnu/parallel/parallel-${finalAttrs.version}.tar.bz2";
    hash = "sha256-T7DS1NFKTvZEjHiMsrz96fvgC41L3GN6fkwI+MVFOlU=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  buildInputs = [
    perl
    procps
  ];

  preInstall = ''
    patchShebangs ./src/parallel
  '';

  postInstall = ''
    wrapProgram $out/bin/parallel \
      --prefix PATH : "${
        lib.makeBinPath [
          procps
          perl
          coreutils
          gawk
        ]
      }"
  '';

  doCheck = true;

  checkTarget = "check";

  meta = {
    description = "Shell tool for executing jobs in parallel";
    homepage = "https://www.gnu.org/software/parallel/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "parallel";
  };
})
