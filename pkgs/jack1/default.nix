{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  alsa-lib,
  db,
  libuuid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jack1";
  version = "0.126.0";

  src = fetchurl {
    url = "https://github.com/jackaudio/jack1/releases/download/${finalAttrs.version}/jack1-${finalAttrs.version}.tar.gz";
    hash = "sha256-eykOnce5JirDKNQe74DBBTyXAT76y++jBHfLmypUReo=";
  };

  configureFlags = [
    "--disable-firewire"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    db
  ];

  propagatedBuildInputs = [ libuuid ];

  meta = {
    description = "JACK audio connection kit";
    homepage = "https://jackaudio.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21
    ];
    platforms = lib.platforms.unix;
  };
})
