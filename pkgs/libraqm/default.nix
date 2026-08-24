{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  freetype,
  harfbuzz,
  fribidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libraqm";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "HOST-Oman";
    repo = "libraqm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3wE2Xr07kFMDw5j6cWwv1cutL2bg7Ia7CdkAx4ysa5A=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    freetype
    harfbuzz
    fribidi
  ];

  doCheck = true;

  meta = {
    description = "Library for complex text layout";
    homepage = "https://github.com/HOST-Oman/libraqm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
