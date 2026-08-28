{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitterentropy-rngd";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-rngd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0t9j2R6AT9RynZFMWYb19wWLZx+Sdg1EVv8jLEslQM4=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    make install DESTDIR= PREFIX=$out UNITDIR=$out/lib/systemd/system

    runHook postInstall
  '';

  # this package internally compiles without optimization by choice,
  # as it introduces more execution time jitter, therefore disable fortify.
  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

  meta = {
    description = "Random number generator, which injects entropy to the kernel";
    homepage = "https://github.com/smuellerDD/jitterentropy-rngd";
    changelog = "https://github.com/smuellerDD/jitterentropy-rngd/releases/tag/${finalAttrs.src.tag}";
    license = [
      lib.licenses.gpl2Only
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.linux;
    mainProgram = "jitterentropy-rngd";
  };
})
