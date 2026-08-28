{
  lib,
  fetchFromGitHub,
  stdenv,
  zlib,
  ninja,
  meson,
  pkg-config,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspng";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "randy408";
    repo = "libspng";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-BiRuPQEKVJYYgfUsglIuxrBoJBFiQ0ygQmAFrVvCz4Q=";
  };

  postPatch = ''
    cat tests/images/meson.build | grep -v "'ch1n3p04'" | grep -v "'ch2n3p08'" > tests/images/meson.build-patched
    mv tests/images/meson.build-patched tests/images/meson.build
  '';

  mesonBuildType = "release";

  mesonFlags = [
    "-Ddev_build=true"
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  buildInputs = [
    zlib
    libpng
  ];

  nativeBuildInputs = [
    ninja
    meson
    meson.configurePhaseHook
    pkg-config
  ];

  meta = {
    description = "Simple, modern libpng alternative";
    homepage = "https://libspng.org/";
    license = with lib.licenses; [ bsd2 ];
    platforms = lib.platforms.all;
  };
})
