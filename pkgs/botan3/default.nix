{
  lib,
  stdenv,
  libcxxStdenv,
  fetchFromGitHub,
  runCommandLocal,
  binutils,
  python3,
  docutils,
  bzip2,
  zlib,
  jitterentropy,
  tpm2-tss,
  static ? stdenv.hostPlatform.isStatic,
  windows,
  withJitterentropy ? false,
  withTpm2 ? false,
  policy ? null,
  exposeSelftests ? false,
}@args:

assert lib.assertOneOf "policy" policy [
  null
  "bsi"
  "fips140"
  "modern"
];

let
  stdenv = if static then libcxxStdenv else args.stdenv;

  empty-libgcc_eh =
    runCommandLocal "empty-libgcc_eh"
      {
        nativeBuildInputs = [ binutils ];
      }
      ''
        mkdir -p "$out"/lib
        ${stdenv.cc.targetPrefix}ar r "$out"/lib/libgcc_eh.a
      '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "botan";
  version = "3.13.0";

  strictDeps = true;

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
    "man"
  ]
  ++ lib.optionals exposeSelftests [
    "selftests"
  ];

  src = fetchFromGitHub {
    owner = "randombit";
    repo = "botan";
    tag = finalAttrs.version;
    hash = "sha256-q4NqsonQw9/lZM27je/CkdxhX9VD8/Iij22aREIMD1A=";
  };

  nativeBuildInputs = [
    python3
    docutils
  ];

  buildInputs = [
    bzip2
    zlib
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withTpm2) [
    tpm2-tss
  ]
  ++ lib.optionals (withJitterentropy && !stdenv.hostPlatform.isMinGW) [
    jitterentropy
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    windows.pthreads
  ];

  propagatedBuildInputs = lib.optional static empty-libgcc_eh;

  buildTargets = [
    "cli"
  ]
  ++ lib.optionals (finalAttrs.finalPackage.doCheck || exposeSelftests) [ "tests" ]
  ++ lib.optionals static [ "static" ]
  ++ lib.optionals (!static) [ "shared" ];

  botanConfigureFlags = [
    "--prefix=$(out)"
    "--bindir=$(bin)/bin"
    "--docdir=$(doc)/share/doc"
    "--mandir=$(man)/share/man"
    "--no-install-python-module"
    "--build-targets=${lib.concatStringsSep "," finalAttrs.buildTargets}"
    "--with-bzip2"
    "--with-zlib"
    "--with-rst2man"
    "--cpu=${stdenv.hostPlatform.parsed.cpu.name}"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    "--cc=clang"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withTpm2) [
    "--with-tpm2"
  ]
  ++ lib.optionals (withJitterentropy && !stdenv.hostPlatform.isMinGW) [
    "--enable-modules=jitter_rng"
  ]
  ++ lib.optionals (policy != null) [
    "--module-policy=${policy}"
  ]
  ++ lib.optionals (policy == "bsi") [
    "--enable-module=ffi"
    "--enable-module=shake"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    "--os=mingw"
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

  postInstall =
    lib.optionalString exposeSelftests ''
      mkdir -p $selftests/bin
      install -Dpm755 -D botan-test $selftests/bin/botan-test

      pushd src/tests/data &> /dev/null
      find . -type d -exec install -d $selftests/test-data/{} \;
      find . -type f -exec install -Dpm644 {} $selftests/test-data/{} \;
      popd &> /dev/null
    ''
    + ''
      cd "$out"/lib/pkgconfig
      ln -s botan-*.pc botan.pc || true
    '';

  doCheck = true;

  meta = {
    description = "Cryptographic algorithms library";
    homepage = "https://botan.randombit.net";
    mainProgram = "botan";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    license = lib.licenses.bsd2;
  };
})
