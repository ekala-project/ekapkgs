{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  python3,
  perlPackages,
  makeWrapper,
}:

let
  perlDeps = [
    perlPackages.CaptureTiny
    perlPackages.DateTime
    perlPackages.DateTimeFormatW3CDTF
    perlPackages.DevelCover
    perlPackages.GD
    perlPackages.JSONXS
    perlPackages.PathTools
    perlPackages.MemoryProcess
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lcov";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fGuOqo8Bj1kDxx7Isu3aaAIBDjoMBr7WuZ+tlErjR4Y=";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  buildInputs = [
    perl
    python3
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.version}"
    "RELEASE=1"
  ];

  preBuild = ''
    patchShebangs --build bin/{fix.pl,get_version.sh} tests/*/*
  '';

  postInstall = ''
    for f in "$out"/bin/{gen*,lcov,llvm2lcov,perl2lcov}; do
      wrapProgram "$f" --set PERL5LIB ${perlPackages.makeFullPerlPath perlDeps}
    done
  '';

  meta = {
    description = "Code coverage tool that enhances GNU gcov";
    homepage = "https://github.com/linux-test-project/lcov";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
