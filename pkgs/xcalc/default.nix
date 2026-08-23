{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxaw,
  libxt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcalc";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcalc-${finalAttrs.version}.tar.xz";
    hash = "sha256-huFXthdGeGdaSpEpldzND/TizjKwG91vkb/pMzMySYA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  meta = {
    description = "Scientific calculator X11 client that can emulate a TI-30 or an HP-10C";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcalc";
    license = with lib.licenses; [
      x11
      hpndSellVariant
    ];
    mainProgram = "xcalc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
