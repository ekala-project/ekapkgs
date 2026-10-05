{
  lib,
  stdenv,
  fetchurl,
  openssl,
  python3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetchmail";
  version = "6.6.9";

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail/fetchmail-${finalAttrs.version}.tar.xz";
    hash = "sha256-PfxHGS52CZtWFPKypCGYy0H6BdfKm1Bz4IwFHpvoFDU=";
  };

  buildInputs = [
    openssl
    python3
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = {
    homepage = "https://www.fetchmail.info/";
    description = "Full-featured remote-mail retrieval and forwarding utility";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "fetchmail";
  };
})
