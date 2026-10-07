{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook2x,
  libarchive,
  libcap_ng,
  lzo,
  pkg-config,
  zstd,
  docbook-xml-dtd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icecream";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = "icecream";
    rev = finalAttrs.version;
    sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook2x
    pkg-config
  ];
  buildInputs = [
    libarchive
    libcap_ng
    lzo
    zstd
    docbook-xml-dtd.v4_5
  ];

  meta = {
    description = "Distributed compiler with a central scheduler to share build load";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
