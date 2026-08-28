{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxvmc";
  version = "1.0.15";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXvMC-${finalAttrs.version}.tar.xz";
    hash = "sha256-T1GK/ePX/UNTRq97No0vc1F/PV+CZHyWLK8/e7j/cHg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxv
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "X-Video Motion Compensation API";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxvmc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
