{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfs";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    tag = "libnfs-${finalAttrs.version}";
    hash = "sha256-uD7PtW2rcpGVzqD6U0DXK1gUaCKlKh+p+i6CW6jLGdw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DENABLE_MULTITHREADING=ON"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "NFS client library";
    homepage = "https://github.com/sahlberg/libnfs";
    license = with lib.licenses; [
      lgpl2
      bsd2
      gpl3
    ];
    platforms = lib.platforms.unix;
  };
})
