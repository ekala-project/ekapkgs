{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
  libffi,
  pugixml,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwire";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AKPaKeLDy0QXRBk/XzR7RktX7CV63ejYsTUgsPdXKvg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    hyprutils
    libffi
    pugixml
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprwire";
    description = "A fast and consistent wire protocol for IPC";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "hyprwire";
  };
})
