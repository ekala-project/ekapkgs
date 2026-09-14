{
  lib,
  stdenv,
  fetchurl,
  perl,
  libunwind,
  buildPackages,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "strace";
  version = "7.1";

  src = fetchurl {
    url = "https://strace.io/files/${finalAttrs.version}/strace-${finalAttrs.version}.tar.xz";
    hash = "sha256-gXQ+zypbRBhrL1A4r9yL7aflxwrtFbT7+8xuns4kSQ8=";
  };

  separateDebugInfo = true;

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  buildInputs = [
    libunwind
  ]
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  configureFlags = [
    "--enable-mpers=check"
  ]
  ++ lib.optional stdenv.cc.isClang "CFLAGS=-Wno-unused-function";

  meta = {
    homepage = "https://strace.io/";
    description = "System call tracer for Linux";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "strace";
  };
})
