{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkcs11-helper";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-0U3HK/6JmdNwus9fs6g86YrTAFVjgK/o7dQb69A5zlU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "Library that simplifies the interaction with PKCS#11 providers";
    homepage = "https://github.com/OpenSC/pkcs11-helper";
    license = with lib.licenses; [
      bsd3
      gpl2Only
    ];
    platforms = lib.platforms.unix;
  };
})
