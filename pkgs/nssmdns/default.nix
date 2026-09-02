{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nss-mdns";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "avahi";
    repo = "nss-mdns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iRaf9/gu9VkGi1VbGpxvC5q+0M8ivezCz/oAKEg5V1M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--enable-avahi"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "MDNS Name Service Switch (NSS) plug-in";
    homepage = "https://github.com/avahi/nss-mdns/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
