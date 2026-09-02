{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  cjson,
  cmocka,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librist";
  version = "0.2.11";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xWqyQl3peB/ENReMcDHzIdKXXCYOJYbhhG8tcSh36dY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    cjson
    cmocka
    mbedtls
  ];

  meta = {
    description = "Library that can be used to easily add the RIST protocol to your application";
    homepage = "https://code.videolan.org/rist/librist";
    license = with lib.licenses; [
      bsd2
      mit
      isc
    ];
    platforms = lib.platforms.all;
  };
})
