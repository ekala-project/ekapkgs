{
  lib,
  stdenv,
  fetchzip,
  xorgproto,
  libx11,
  libxext,
  libxrandr,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slock";
  version = "1.6";

  src = fetchzip {
    url = "https://dl.suckless.org/tools/slock-${finalAttrs.version}.tar.gz";
    hash = "sha256-EIzLEIGd631dwYoAe7PXNoki9iaQPP3Y0S5H80aY+l8=";
  };

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxrandr
    libxcrypt
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  makeFlags = [ "CC:=$(CC)" ];

  meta = {
    description = "Simple X display locker";
    homepage = "https://tools.suckless.org/slock";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "slock";
  };
})
