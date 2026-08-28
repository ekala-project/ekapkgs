{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  docutils,
  bzip2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "botan";
  version = "3.12.0";

  __structuredAttrs = true;
  enableParallelBuilding = true;
  strictDeps = true;

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "randombit";
    repo = "botan";
    tag = finalAttrs.version;
    hash = "sha256-2ODTjqsWSmlornOKh5m6pOX7cNOBHS3+ALblRyC8lPw=";
  };

  nativeBuildInputs = [
    python3
    docutils
  ];

  buildInputs = [
    bzip2
    zlib
  ];

  buildTargets = [
    "cli"
    "tests"
    "shared"
  ];

  botanConfigureFlags = [
    "--prefix=${placeholder "out"}"
    "--bindir=${placeholder "bin"}/bin"
    "--docdir=${placeholder "doc"}/share/doc"
    "--mandir=${placeholder "man"}/share/man"
    "--no-install-python-module"
    "--build-targets=${lib.concatStringsSep "," finalAttrs.buildTargets}"
    "--with-bzip2"
    "--with-zlib"
    "--with-rst2man"
    "--cpu=${stdenv.hostPlatform.parsed.cpu.name}"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    "--cc=clang"
  ];

  configurePhase = ''
    runHook preConfigure
    python configure.py ''${botanConfigureFlags[@]}
    runHook postConfigure
  '';

  preInstall = ''
    if [ -d src/scripts ]; then
      patchShebangs src/scripts
    fi
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  doCheck = true;

  meta = {
    description = "Cryptographic algorithms library";
    homepage = "https://botan.randombit.net";
    mainProgram = "botan";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
})
