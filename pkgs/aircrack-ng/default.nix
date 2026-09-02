{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  openssl,
  sqlite,
  pcre2,
  libpcap,
  zlib,
  libnl,
  iw,
  ethtool,
  pciutils,
  usbutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aircrack-ng";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "aircrack-ng";
    tag = finalAttrs.version;
    hash = "sha256-niQDwiqi5GtBW5HIn0endnqPb/MqllcjsjXw4pTyFKY=";
  };

  configureFlags = [
    "--with-experimental"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoreconfHook
  ];

  buildInputs = [
    openssl
    libpcap
    zlib
    libnl
    iw
    ethtool
    pciutils
    sqlite
    pcre2
  ];

  postFixup = ''
    wrapProgram "$out/bin/airmon-ng" --prefix PATH : ${
      lib.escapeShellArg (
        lib.makeBinPath [
          ethtool
          iw
          pciutils
          usbutils
        ]
      )
    }
  '';

  meta = {
    description = "WiFi security auditing tools suite";
    homepage = "https://www.aircrack-ng.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
