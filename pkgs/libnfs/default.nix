{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfs";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    tag = "libnfs-${finalAttrs.version}";
    hash = "sha256-sOw0qpxivseIEN+5FKhVDleyDx9ktimlXhMfFBn9oQ4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    ENABLE_MULTITHREADING = true;
  };

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
