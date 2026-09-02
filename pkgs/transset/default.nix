{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transset";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/transset-${finalAttrs.version}.tar.xz";
    hash = "sha256-gamrdK8TdzOqjLajf4KSlIUm/n7wa4WfwP8nLEN8Czg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    xorgproto
  ];

  meta = {
    description = "Utility for setting opacity/transparency property on a window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/transset";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      hpndSellVariant
    ];
    platforms = lib.platforms.unix;
    mainProgram = "transset";
  };
})
