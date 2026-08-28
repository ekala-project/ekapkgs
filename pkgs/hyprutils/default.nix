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
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jAcsogZwWMfXT9MfXxZzkwliAqIuZUV0p71h6Ba9ReE=";
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
