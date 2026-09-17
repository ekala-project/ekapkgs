{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPackages,
  cargo,
  m4,
  perl,
  pkg-config,
  python3,
  rust-cbindgen,
  rustPlatform,
  rustc,
  which,
  zip,
  icu,
  nspr,
  readline,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spidermonkey";
  version = "140.13.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${finalAttrs.version}esr/source/firefox-${finalAttrs.version}esr.source.tar.xz";
    hash = "sha512-k3pBA9ccXh5L8FGCFyn26nC1wY1ESTCkh2lcwj10cSoBNARySPasAjBeAb7LcFQmpVudiXOfAqAe2gHs9bwn8Q==";
  };

  patches = [
    ./always-check-for-pkg-config-128.patch
    ./allow-system-s-nspr-and-icu-on-bootstrapped-sysroot-128.patch
    # mozjs-140.pc does not contain -DXP_UNIX on Linux
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mozjs140/raw/49492baa47bc1d7b7d5bc738c4c81b4661302f27/f/9aa8b4b051dd539e0fbd5e08040870b3c712a846.patch";
      hash = "sha256-SsyO5g7wlrxE7y2+VTHfmUDamofeZVqge8fv2y0ZhuU=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    ./fix-32bit-build.patch
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "i686-linux") [
    ./fix-float-i686.patch
  ];

  nativeBuildInputs = [
    cargo
    m4
    perl
    pkg-config
    python3
    rustc
    rustc.llvmPackages.llvm
    which
    zip
    rust-cbindgen
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    icu
    nspr
    readline
    zlib
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  setOutputFlags = false;

  configureFlags = [
    "--with-intl-api"
    "--with-system-icu"
    "--with-system-nspr"
    "--with-system-zlib"
    "--enable-optimize"
    "--enable-readline"
    "--enable-release"
    "--enable-shared-js"
    "--disable-debug"
    "--includedir=${placeholder "dev"}/include"
    "--disable-jemalloc"
    "--disable-strip"
    "--disable-tests"
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"
  ];

  configurePlatforms = [ ];

  enableParallelBuilding = true;

  preConfigure = ''
    export MOZBUILD_STATE_PATH=$TMPDIR/mozbuild
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python3.interpreter}"
    export M4=m4
    export AWK=awk
    export AS=$CC
    export AC_MACRODIR=$PWD/build/autoconf/
    patchShebangs build/cargo-linker
    mkdir obj
    cd obj/
    configureScript=../js/src/configure
  '';

  env.NIX_CFLAGS_COMPILE = "-Wformat";

  preFixup = ''
    moveToOutput bin/js${lib.versions.major finalAttrs.version}-config "$dev"
    rm $out/lib/libjs_static.ajs
    ln -s $out/bin/js${lib.versions.major finalAttrs.version} $out/bin/js
  '';

  meta = {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://spidermonkey.dev/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
  };
})
