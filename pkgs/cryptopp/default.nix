{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "crypto++";
  version = "8.9.0";
  underscoredVersion = lib.strings.replaceStrings [ "." ] [ "_" ] version;

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_${underscoredVersion}";
    hash = "sha256-HV+afSFkiXdy840JbHBTR8lLL0GMwsN3QdwaoQmicpQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace "AR = /usr/bin/libtool" "AR = ar" \
      --replace "ARFLAGS = -static -o" "ARFLAGS = -cru"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildFlags = [
    "shared"
    "libcryptopp.pc"
  ];

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];

  doCheck = true;

  installTargets = [ "install-lib" ];
  installFlags = [ "LDCONF=true" ];

  meta = {
    description = "Free C++ class library of cryptographic schemes";
    homepage = "https://cryptopp.com/";
    license = with lib.licenses; [
      boost
      publicDomain
    ];
    platforms = lib.platforms.all;
  };
}
