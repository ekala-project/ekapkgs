{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqb,
  libxml2,
  libnl,
  lksctp-tools,
  nss,
  openssl,
  bzip2,
  lzo,
  lz4,
  xz,
  zlib,
  zstd,
  doxygen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kronosnet";
  version = "1.35";

  src = fetchFromGitHub {
    owner = "kronosnet";
    repo = "kronosnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UY9smrku7bryXYXWrMtaUrY9oh6FKWtiVlwrZiYwSUc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    doxygen
  ];

  configureFlags = [ "--disable-wireshark-dissector" ];

  buildInputs = [
    libqb
    libxml2
    libnl
    lksctp-tools
    nss
    openssl
    bzip2
    lzo
    lz4
    xz
    zlib
    zstd
  ];

  meta = {
    description = "VPN on steroids";
    homepage = "https://kronosnet.org/";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
  };
})
