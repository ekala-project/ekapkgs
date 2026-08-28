{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  swaybg,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  scdoc,
  libGL,
  wayland,
  libxkbcommon,
  pcre2,
  json_c,
  libevdev,
  pango,
  cairo,
  libinput,
  gdk-pixbuf,
  librsvg,
  wlroots,
  wayland-protocols,
  libdrm,
  # Used by the NixOS module:
  isNixOS ? false,
  # TODO: xwayland fails to build (libtirpc broken in corepkgs); disable until fixed
  enableXWayland ? false,
  libxcb-wm,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  trayEnabled ? systemdSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sway-unwrapped";
  version = "1.12";

  inherit
    enableXWayland
    isNixOS
    systemdSupport
    trayEnabled
    ;
  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = finalAttrs.version;
    hash = "sha256-OcF7jOOHhFPhM5APn5riy8S5jsEr9jALCVh9nBtD7Nk=";
  };

  patches = [
    ./load-configuration-from-etc.patch

    (replaceVars ./fix-paths.patch {
      inherit swaybg;
    })
  ]
  ++ lib.optionals (!finalAttrs.isNixOS) [
    ./sway-config-no-nix-store-references.patch
  ];

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    scdoc
  ];

  buildInputs = [
    libGL
    wayland
    libxkbcommon
    pcre2
    json_c
    libevdev
    pango
    cairo
    libinput
    gdk-pixbuf
    librsvg
    wayland-protocols
    libdrm
    (wlroots.override { inherit (finalAttrs) enableXWayland; })
  ]
  ++ lib.optionals finalAttrs.enableXWayland [
    libxcb-wm
  ];

  mesonBuildType = "release";

  mesonFlags =
    let
      inherit (lib.strings) mesonEnable mesonOption;
      sd-bus-provider = if systemdSupport then "libsystemd" else "basu";
    in
    [
      (mesonOption "sd-bus-provider" sd-bus-provider)
      (mesonEnable "tray" finalAttrs.trayEnabled)
    ];

  passthru = {
    providedSessions = [ "sway" ];
  };

  meta = {
    description = "I3-compatible tiling Wayland compositor";
    homepage = "https://swaywm.org";
    changelog = "https://github.com/swaywm/sway/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "sway";
  };
})
