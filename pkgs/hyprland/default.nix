{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  cmake,
  aquamarine,
  binutils,
  cairo,
  glaze,
  glslang,
  hyprcursor,
  hyprgraphics,
  hyprlang,
  hyprutils,
  hyprwire,
  hyprwayland-scanner,
  lcms2,
  libGL,
  libdrm,
  libgbm,
  libinput,
  libuuid,
  libxkbcommon,
  lua5_5,
  muparser,
  pango,
  pciutils,
  pkgconf,
  python3,
  re2,
  systemdMinimal,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  libxcb-errors,
  libxdmcp,
  libxcursor,
  libxcb,
  xwayland,
  debug ? false,
  enableXWayland ? true,
  withSystemd ? true,
  wrapRuntimeDeps ? true,
}:
let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) concatLists optionals;
  inherit (lib.strings)
    makeBinPath
    optionalString
    cmakeBool
    ;
  inherit (lib.trivial) importJSON;

  info = importJSON ./info.json;

in
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + optionalString debug "-debug";
  version = "0.55.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-IuT0HnOr/0rAw+GXr+OwWx89FjA4Og1FqP7vywEwRJM=";
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    substituteInPlace src/render/types.hpp \
      --replace-fail /usr $out

    # Remove extra @PREFIX@ to fix pkg-config paths
    substituteInPlace hyprland.pc.in \
      --replace-fail  "@PREFIX@/" ""
    substituteInPlace example/hyprland.desktop.in \
      --replace-fail  "@PREFIX@/" ""
  '';

  env = {
    GIT_BRANCH = info.branch;
    GIT_COMMITS = "-1";
    GIT_COMMIT_DATE = info.date;
    GIT_DIRTY = "clean";
    GIT_COMMIT_HASH = info.commit_hash;
    GIT_COMMIT_MESSAGE = info.commit_message;
    GIT_TAG = info.tag;
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    hyprwayland-scanner
    hyprwire
    makeWrapper
    cmake
    cmake.configurePhaseHook
    pkg-config
    wayland-scanner
    python3
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = concatLists [
    [
      aquamarine
      cairo
      glaze
      glslang
      hyprcursor.dev
      hyprgraphics
      hyprlang
      hyprutils
      lcms2
      libGL
      libdrm
      libgbm
      libinput
      libuuid
      libxcursor
      libxkbcommon
      lua5_5
      muparser
      pango
      pciutils
      re2
      tomlplusplus
      wayland
      wayland-protocols
    ]
    (optionals enableXWayland [
      libxcb
      libxcb-errors
      libxcb-wm
      libxdmcp
      xwayland
    ])
    (optionals withSystemd [ systemdMinimal ])
  ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;
  strictDeps = true;

  cmakeFlags = mapAttrsToList cmakeBool {
    "BUILT_WITH_NIX" = true;
    "NO_XWAYLAND" = !enableXWayland;
    "NO_SYSTEMD" = !withSystemd;
    "CMAKE_DISABLE_PRECOMPILE_HEADERS" = true;
    "NO_UWSM" = true;
    "TRACY_ENABLE" = false;
  };

  postInstall = ''
    ${optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${
          makeBinPath [
            binutils
            pciutils
            pkgconf
          ]
        }
    ''}
  '';

  passthru = {
    providedSessions = [ "hyprland" ];
  };

  meta = {
    homepage = "https://github.com/hyprwm/Hyprland";
    changelog = "https://github.com/hyprwm/Hyprland/releases/tag/v${finalAttrs.version}";
    description = "Dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux;
  };
})
