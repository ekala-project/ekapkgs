{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdftopcf";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/util/bdftopcf-${finalAttrs.version}.tar.xz";
    hash = "sha256-vGC+WQQzD6qj3dKu14dL7i8p5Dh8JF1nh1UvBn6wUjo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  meta = {
    description = "Converts X font from Bitmap Distribution Format to Portable Compiled Format";
    homepage = "https://gitlab.freedesktop.org/xorg/util/bdftopcf";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "bdftopcf";
    platforms = lib.platforms.unix;
  };
})
