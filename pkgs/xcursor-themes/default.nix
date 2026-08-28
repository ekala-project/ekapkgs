{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xcursorgen,
  xorgproto,
  libxcursor,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcursor-themes";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xcursor-themes-${finalAttrs.version}.tar.xz";
    hash = "sha256-lbro9Igj2JSgW/Qt+/RTZ0q3296xHivAeehSWtRzeMg=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    xcursorgen
  ];
  buildInputs = [
    xorgproto
    libxcursor
  ];

  configureFlags = [ "--with-cursordir=$(out)/share/icons" ];

  meta = {
    description = "Default set of cursor themes for use with libxcursor.";
    homepage = "https://gitlab.freedesktop.org/xorg/data/cursors";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
