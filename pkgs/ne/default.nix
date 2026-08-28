{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  texinfo,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ne";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "vigna";
    repo = "ne";
    tag = finalAttrs.version;
    hash = "sha256-n8PERQD9G4jmW4avQjbFofrSapyRoSbQ2k1LzVt0i1o=";
  };

  postPatch = ''
    substituteInPlace makefile --replace-fail "./version.pl" "perl version.pl"
    substituteInPlace src/makefile --replace-fail "-lcurses" "-lncurses"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    texinfo
    perl
  ];
  buildInputs = [ ncurses ];

  # Build only the binary, skip docs that require texlive/ghostscript
  buildPhase = ''
    runHook preBuild
    make -C src NE_GLOBAL_DIR=${placeholder "out"}/share/ne
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/ne/syntax $out/share/ne/macros $out/share/man/man1
    cp src/ne $out/bin/
    cp extensions $out/share/ne/
    cp syntax/*.jsf $out/share/ne/syntax/
    cp macros/* $out/share/ne/macros/
    cp doc/ne.1 $out/share/man/man1/
    runHook postInstall
  '';

  meta = {
    description = "Nice editor";
    homepage = "https://ne.di.unimi.it/";
    changelog = "https://github.com/vigna/ne/releases/tag/${finalAttrs.version}";
    downloadPage = "https://github.com/vigna/ne";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "ne";
  };
})
