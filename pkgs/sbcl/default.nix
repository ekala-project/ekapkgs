{
  lib,
  stdenv,
  ecl,
  coreutils,
  fetchurl,
  ps,
  strace,
  texinfo,
  which,
  writableTmpDirAsHomeHook,
  writeText,
  zstd,
}:

stdenv.mkDerivation (self: {
  pname = "sbcl";
  version = "2.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/sbcl/sbcl/${self.version}/sbcl-${self.version}-source.tar.bz2";
    sha256 = "sha256-XxS07ZKUKp44dZT6wAC5bbdGfpzlYTBn/8CSPfPsIHI=";
  };

  nativeBuildInputs = [
    texinfo
  ]
  ++ lib.optionals self.doCheck (
    [
      which
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals (builtins.elem stdenv.system strace.meta.platforms) [
      strace
    ]
    ++ [ ps ]
  );

  buildInputs = lib.optionals self.coreCompression [ zstd ];

  threadSupport = (
    stdenv.hostPlatform.isx86
    || "aarch64-linux" == stdenv.hostPlatform.system
    || "aarch64-darwin" == stdenv.hostPlatform.system
  );

  purgeNixReferences = false;
  coreCompression = true;
  markRegionGC = self.threadSupport;
  disableImmobileSpace = false;
  linkableRuntime = stdenv.hostPlatform.isx86;

  disabledTestFiles = [
    "debug.impure.lisp"
  ]
  ++
    lib.optionals
      (builtins.elem stdenv.hostPlatform.system [
        "x86_64-linux"
        "aarch64-linux"
      ])
      [
        "foreign-stack-alignment.impure.lisp"
        "compiler.pure.lisp"
        "float.pure.lisp"
      ]
  ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
    "traceroot.impure.lisp"
    "futex-wait.test.sh"
  ];

  patches = [
    ./dynamic-space-size-envvar-2.5.3-feature.patch
    ./dynamic-space-size-envvar-2.5.3-tests.patch
  ];

  sbclPatchPhase =
    lib.optionalString (self.disabledTestFiles != [ ]) ''
      (cd tests ; rm -f ${lib.concatStringsSep " " self.disabledTestFiles})
    ''
    + ''
      (
        shopt -s nullglob
        substituteInPlace {tests,src/code}/*.{lisp,sh} \
          --replace-quiet /usr/bin/env "${coreutils}/bin/env" \
          --replace-quiet /bin/uname "${coreutils}/bin/uname" \
          --replace-quiet /bin/sh "${stdenv.shell}"
      )
      if [[ ! -a version.lisp-expr ]]; then
        echo '"${self.version}.nixos"' > version.lisp-expr
      fi
    '';

  preConfigurePhases = "sbclPatchPhase";

  enableFeatures =
    lib.optional self.threadSupport "sb-thread"
    ++ lib.optional self.linkableRuntime "sb-linkable-runtime"
    ++ lib.optional self.coreCompression "sb-core-compression"
    ++ lib.optional stdenv.hostPlatform.isAarch32 "arm"
    ++ lib.optional self.markRegionGC "mark-region-gc";

  disableFeatures =
    lib.optional (!self.threadSupport) "sb-thread"
    ++ lib.optionals self.disableImmobileSpace [
      "immobile-space"
      "immobile-code"
      "compact-instance-header"
    ];

  buildArgs = [
    "--prefix=$out"
    "--xc-host=${lib.escapeShellArg "${lib.getExe ecl} --norc"}"
  ]
  ++ builtins.map (x: "--with-${x}") self.enableFeatures
  ++ builtins.map (x: "--without-${x}") self.disableFeatures
  ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
    "--arch=arm64"
  ];

  # Fails to find `O_LARGEFILE` otherwise.
  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  buildPhase = ''
    runHook preBuild

    export INSTALL_ROOT=$out
    sh make.sh ${lib.concatStringsSep " " self.buildArgs}
    (cd doc/manual ; make info)

    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    sh install.sh

    cp -r src $out/lib/sbcl
    cp -r contrib $out/lib/sbcl
    cat >$out/lib/sbcl/sbclrc <<EOF
     (setf (logical-pathname-translations "SYS")
       '(("SYS:SRC;**;*.*.*" #P"$out/lib/sbcl/src/**/*.*")
         ("SYS:CONTRIB;**;*.*.*" #P"$out/lib/sbcl/contrib/**/*.*")))
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Common Lisp compiler";
    homepage = "https://sbcl.org";
    license = lib.licenses.publicDomain;
    mainProgram = "sbcl";
    maintainers = [ ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
