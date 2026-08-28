{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "Mbed-TLS";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    hash = "sha256-+PW41/c8M/Yz0EVWM4Gt4HTNBMUTU5MayaKVZ+upLIo=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/openwrt/openwrt/52b6c9247997e51a97f13bb9e94749bc34e2d52e/package/libs/mbedtls/patches/100-fix-gcc14-build.patch";
      hash = "sha256-20bxGoUHkrOEungN3SamYKNgj95pM8IjbisNRh68Wlw=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    perl
    python3
  ];

  strictDeps = true;

  postConfigure = ''
    perl scripts/config.pl set MBEDTLS_THREADING_C
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD
  '';

  cmakeFlags = [
    "-DUSE_SHARED_MBEDTLS_LIBRARY=on"
    "-DGEN_FILES=off"
  ];

  doCheck = false;

  meta = {
    homepage = "https://www.trustedfirmware.org/projects/mbed-tls/";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = [
      lib.licenses.asl20
      lib.licenses.gpl2Plus
    ];
    platforms = lib.platforms.all;
  };
}
