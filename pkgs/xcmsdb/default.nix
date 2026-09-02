{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcmsdb";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcmsdb-${finalAttrs.version}.tar.xz";
    hash = "sha256-XsQGjkiBh7BeqS7hNiyWt4qQ8ZzMehhExZIdcGJrvDg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libx11 ];

  meta = {
    description = "Device Color Characterization utility for X Color Management System";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcmsdb";
    license = with lib.licenses; [
      hpnd
      mitOpenGroup
    ];
    mainProgram = "xcmsdb";
    platforms = lib.platforms.unix;
  };
})
