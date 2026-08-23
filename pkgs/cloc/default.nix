{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cloc";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-B5dk22H5FeWZ+12A7iwAsJ0ORVfI1stDfue9ZgXBOg4=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [
    perl
    AlgorithmDiff
    ParallelForkManager
    RegexpCommon
  ];

  makeFlags = [
    "prefix="
    "DESTDIR=$(out)"
    "INSTALL=install"
  ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Program that counts lines of source code";
    homepage = "https://github.com/AlDanial/cloc";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "cloc";
  };
})
