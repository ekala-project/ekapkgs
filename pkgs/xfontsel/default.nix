{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  xorgproto,
  libx11,
  libxaw,
  libxmu,
  libxt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfontsel";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xfontsel-${finalAttrs.version}.tar.xz";
    hash = "sha256-eP8Bh1fHsiE3z101Ju9ek4i8DN6tHwDa8siY4uJ0VT8=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxmu
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  meta = {
    description = "Allows testing the fonts available in an X server";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xfontsel";
    license = with lib.licenses; [ x11 hpnd mit ];
    mainProgram = "xfontsel";
    platforms = lib.platforms.unix;
  };
})
