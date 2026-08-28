{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsquish";
  version = "1.15";

  src = fetchurl {
    url = "mirror://sourceforge/project/libsquish/libsquish-${finalAttrs.version}.tgz";
    hash = "sha256-YoeW7rpgiGYYOmHQgNRpZ8ndpnI7wKPsUjJMhdIUcmk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ]
  ++ lib.optional (!stdenv.hostPlatform.isx86) (lib.cmakeBool "BUILD_SQUISH_WITH_SSE2" false);

  meta = {
    description = "Library for compressing images with the DXT/S3TC standard";
    homepage = "https://libsquish.sourceforge.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
