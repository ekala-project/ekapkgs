{
  lib,
  gcc15Stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dpmeFq5vPvSOsi30ZchOLjltAZEuVBucDvGKs3IZYf4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeBuildType = "RelWithDebInfo";

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    changelog = "https://github.com/hyprwm/hyprutils/releases/tag/v${finalAttrs.version}";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
