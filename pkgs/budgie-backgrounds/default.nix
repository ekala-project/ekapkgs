{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  jhead,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-backgrounds";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-veUGYYUIHfz8MTaVNWaOkWl2byWEQhTSp9iikSPcHsw=";
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    description = "Default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    license = lib.licenses.cc0;
    platforms = lib.platforms.linux;
  };
})
