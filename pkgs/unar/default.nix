{
  lib,
  clangStdenv,
  fetchFromGitHub,
  installShellFiles,
  gnustep-base,
  bzip2,
  zlib,
  icu,
  openssl,
  wavpack,
}:
let
  stdenv = clangStdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "unar";
  version = "1.10.8";

  srcs = [
    (fetchFromGitHub rec {
      owner = "MacPaw";
      repo = "XADMaster";
      name = repo;
      rev = "v${finalAttrs.version}";
      hash = "sha256-dmIyxpa3pq4ls4Grp0gy/6ZjcaA7rmobMn4h1inVgns=";
    })
    (fetchFromGitHub {
      owner = "MacPaw";
      repo = "universal-detector";
      name = "UniversalDetector";
      rev = "1.1";
      hash = "sha256-6X1HtXhRuRwBOq5TAtL1I/vBBZokZOXIQ+oaRFigtv8=";
    })
  ];

  postPatch = ''
    substituteInPlace unar.m lsar.m \
      --replace-fail "v1.10.7" "v${finalAttrs.version}"
    for f in Makefile.linux ../UniversalDetector/Makefile.linux ; do
      substituteInPlace $f \
        --replace "= gcc" "=${stdenv.cc.targetPrefix}cc" \
        --replace "= g++" "=${stdenv.cc.targetPrefix}c++" \
        --replace "-DGNU_RUNTIME=1" "" \
        --replace "-fgnu-runtime" "-fobjc-runtime=gnustep-2.0"
    done
    chmod +w ../UniversalDetector -R
  '';

  buildInputs = [
    bzip2
    icu
    openssl
    wavpack
    zlib
    gnustep-base
  ];

  nativeBuildInputs = [ installShellFiles ];

  makefile = "Makefile.linux";

  dontConfigure = true;
  sourceRoot = "XADMaster";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin {lsar,unar}
    for f in lsar unar; do
      installManPage ./Extra/$f.?
      installShellCompletion --bash --name $f ./Extra/$f.bash_completion
    done

    runHook postInstall
  '';

  meta = {
    broken = true; # build failure
    homepage = "https://theunarchiver.com";
    description = "Archive unpacker program";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "unar";
    platforms = lib.platforms.unix;
  };
})
