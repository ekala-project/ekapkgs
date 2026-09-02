{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  cjson ? null,
  db ? null,
  gmp,
  libxml2,
  ncurses,
  help2man ? null,
  texinfo ? null,
  texliveBasic ? null,
  perl,
}:
let
  nistTestSuite = fetchurl {
    url = "mirror://sourceforge/gnucobol/newcob.val.tar.gz";
    hash = "sha256-5FE/JqmziRH3v4gv49MzmoC0XKvCyvheswVbD1zofuA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnucobol";
  version = "3.2";

  src = fetchurl {
    url = "mirror://gnu/gnucobol/gnucobol-${finalAttrs.version}.tar.xz";
    hash = "sha256-O7SK9GztR3n6z0H9wu5g5My4bqqZ0BCzZoUxXfOcLuI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    help2man
    libtool
    perl
    texinfo
    texliveBasic
  ];

  buildInputs = [
    cjson
    db
    gmp
    libxml2
    ncurses
  ];

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];

  propagatedBuildOutputs = [ ];

  patches = [
    ./fix-libxml2-include.patch
  ];

  postPatch = ''
    sed -i '/^AT_CHECK.*crud\.cob/i AT_SKIP_IF([true])' tests/testsuite.src/listings.at
    sed -i "/^843;/d" tests/testsuite
    sed -i "/^875;/d" tests/testsuite
    sed -i "214i @end verbatim" doc/cbrunt.tex
  '';

  preConfigure = ''
    autoconf
    aclocal
    automake
  '';

  env.CFLAGS =
    let
      gcc15Flags = "-Wno-error=incompatible-pointer-types -std=gnu11";
    in
    if stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "15.0.0" then gcc15Flags else "";

  enableParallelBuilding = true;

  installFlags = [
    "install-pdf"
    "install-html"
    "localedir=$out/share/locale"
  ];

  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make check

    cp -v ${nistTestSuite} ./tests/cobol85/newcob.val.tar.gz
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make test

    message="Hello, COBOL!"
    tee hello.cbl <<EOF
           IDENTIFICATION DIVISION.
           PROGRAM-ID. HELLO.

           PROCEDURE DIVISION.
           DISPLAY "$message".
           STOP RUN.
    EOF
    $bin/bin/cobc -x -o hello-cobol "hello.cbl"
    hello="$(./hello-cobol | tee >(cat >&2))"
    [[ "$hello" == "$message" ]] || exit 1

    runHook postInstallCheck
  '';

  meta = {
    description = "Free/libre COBOL compiler";
    homepage = "https://gnu.org/software/gnucobol/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    mainProgram = "cobc";
    platforms = lib.platforms.all;
  };
})
