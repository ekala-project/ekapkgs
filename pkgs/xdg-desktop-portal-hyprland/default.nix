{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  # TODO: Qt6 packages not yet available in ekapkgs
  # wrapQtAppsHook,
  hyprland,
  hyprland-protocols,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  libdrm,
  libgbm,
  pipewire,
  # TODO: Qt6 packages not yet available
  # qtbase,
  # qttools,
  # qtwayland,
  sdbus-cpp_2,
  slurp,
  wayland,
  wayland-protocols,
  wayland-scanner,
  debug ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-hyprland";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "xdg-desktop-portal-hyprland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B7nwX0PE0KBo1/ZtuwJtA7dBG6gdPW5tSBb0skY8DHA=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    makeWrapper
    pkg-config
    # TODO: wrapQtAppsHook (Qt6 not yet available)
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    hyprutils
    libdrm
    libgbm
    pipewire
    # TODO: Qt6 packages not yet available
    # qtbase
    # qttools
    # qtwayland
    sdbus-cpp_2
    wayland
    wayland-protocols
    wayland-scanner
  ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;

  # TODO: re-enable when Qt6 is available
  # dontWrapQtApps = true;

  postInstall = ''
    wrapProgramShell $out/libexec/xdg-desktop-portal-hyprland \
      --prefix PATH ":" ${lib.makeBinPath [ (placeholder "out") ]}
  '';

  meta = {
    description = "xdg-desktop-portal backend for Hyprland";
    homepage = "https://github.com/hyprwm/xdg-desktop-portal-hyprland";
    changelog = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/releases/tag/v${finalAttrs.version}";
    mainProgram = "hyprland-share-picker";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
