{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcompmgr";
  version = "1.1.10";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcompmgr-${finalAttrs.version}.tar.xz";
    hash = "sha256-eCT3CcTyJDLq6nVC7JM4Tl3Uj2/LhcEv+C1yFCOwuY8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrender
  ];

  meta = {
    description = "Sample X11 compositing manager";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcompmgr";
    license = lib.licenses.hpndSellVariant;
    platforms = lib.platforms.unix;
    mainProgram = "xcompmgr";
  };
})
