{
  lib,
  copyPkgconfigItems,
  fetchzip,
  makePkgconfigItem,
  perl,
  stdenv,
  texinfo,
  which,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tcc";
  version = "0.9.27-unstable-2025-01-06";

  outputs = [
    "dev"
    "doc"
    "info"
    "lib"
    "man"
    "out"
  ];

  src = fetchzip {
    url = "https://repo.or.cz/tinycc.git/snapshot/f6385c05308f715bdd2c06336801193a21d69b50.tar.gz";
    hash = "sha256-tO3N+NplYy8QUOC2N3x0CO5Ui75j9bQzLSZQF1HQyhY=";
  };

  nativeBuildInputs = [
    copyPkgconfigItems
    perl
    texinfo
    which
  ];

  strictDeps = true;

  pkgconfigItems =
    let
      libtcc-pcitem = {
        name = "libtcc";
        inherit (finalAttrs) version;
        cflags = [ "-I${libtcc-pcitem.variables.includedir}" ];
        libs = [
          "-L${libtcc-pcitem.variables.libdir}"
          "-Wl,--rpath ${libtcc-pcitem.variables.libdir}"
          "-ltcc"
        ];
        variables = {
          prefix = "${placeholder "out"}";
          includedir = "${placeholder "dev"}/include";
          libdir = "${placeholder "lib"}/lib";
        };
        description = "Tiny C compiler backend";
      };
    in
    [
      (makePkgconfigItem libtcc-pcitem)
    ];

  configureFlags = [
    "--cc=$CC"
    "--ar=$AR"
    "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
    "--sysincludepaths=${
      lib.concatStringsSep ":" ([
        "{B}/include"
        "${lib.getDev stdenv.cc.libc}/include"
      ])
    }"
    "--libpaths=$lib/lib/tcc:$lib/lib:${lib.getLib stdenv.cc.libc}/lib"
    "--enable-cross"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--config-musl"
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
    "-Wno-error=int-conversion"
  ];

  doInstallCheck =
    !stdenv.hostPlatform.isStatic && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    patchShebangs texi2pod.pl
  '';

  preConfigure = ''
    echo ${finalAttrs.version} > VERSION
    configureFlagsArray+=("--elfinterp=$(< $NIX_CC/nix-support/dynamic-linker)")
  '';

  installCheckTarget = "test";

  meta = {
    homepage = "https://repo.or.cz/tinycc.git";
    description = "Small, fast, and embeddable C compiler and interpreter";
    longDescription = ''
      TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike other C
      compilers, it is meant to be self-sufficient: you do not need an external
      assembler or linker because TCC does that for you.

      TCC compiles so fast that even for big projects Makefiles may not be
      necessary.

      TCC not only supports ANSI C, but also most of the new ISO C99 standard
      and many GNU C extensions.

      TCC can also be used to make C scripts, i.e. pieces of C source that you
      run as a Perl or Python script.  Compilation is so fast that your script
      will be as fast as if it was an executable.

      TCC can also automatically generate memory and bound checks while allowing
      all C pointers operations.  TCC can do these checks even if non patched
      libraries are used.

      With libtcc, you can use TCC as a backend for dynamic code generation.
    '';
    license = lib.licenses.lgpl21Only;
    mainProgram = "tcc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
