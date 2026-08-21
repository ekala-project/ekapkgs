{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtrans";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/xtrans-${finalAttrs.version}.tar.xz";
    hash = "sha256-+q/qFmvyRRoXPZ1ZM1KUDsZAQUXF0dpcITQjzk01npI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "X Window System Protocols Transport layer shared code";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxtrans";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      mit
      x11
      hpndSellVariant
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xtrans" ];
    platforms = lib.platforms.unix;
  };
})
