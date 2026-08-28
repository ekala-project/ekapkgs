{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxres";
  version = "1.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXres-${finalAttrs.version}.tar.xz";
    hash = "sha256-0t6PVAHWyGqJknkWVFR+uN71hd/cDAjMFuJO9q7radw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "X-Resource extension client library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxres";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
