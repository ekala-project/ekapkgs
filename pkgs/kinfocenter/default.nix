{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  replaceVars,
  aha,
  clinfo,
  dmidecode,
  iproute2,
  libdisplay-info,
  libusb1,
  lm_sensors,
  mesa-demos,
  pciutils,
  pulseaudio,
  systemsettings ? null, # TODO: not yet in ekapkgs
  util-linux,
  vulkan-tools,
  wayland-utils,
  xdpyinfo,
  kauth,
  kcmutils,
  kcodecs,
  kcompletion,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kjobwidgets,
  kservice,
  kwindowsystem,
  solid,
}:
let
  tools = {
    aha = lib.getExe aha;
    clinfo = lib.getExe clinfo;
    di_edid_decode = lib.getExe libdisplay-info;
    dmidecode = lib.getExe' dmidecode "dmidecode";
    eglinfo = lib.getExe' mesa-demos "eglinfo";
    glxinfo = lib.getExe' mesa-demos "glxinfo";
    ip = lib.getExe' iproute2 "ip";
    lsblk = lib.getExe' util-linux "lsblk";
    lspci = lib.getExe' pciutils "lspci";
    lscpu = lib.getExe' util-linux "lscpu";
    pactl = lib.getExe' pulseaudio "pactl";
    qdbus = lib.getExe' qt6.qttools "qdbus";
    sensors = lib.getExe' lm_sensors "sensors";
    vulkaninfo = lib.getExe' vulkan-tools "vulkaninfo";
    waylandinfo = lib.getExe wayland-utils;
    xdpyinfo = lib.getExe xdpyinfo;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kinfocenter";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kinfocenter-${finalAttrs.version}.tar.xz";
    hash = "sha256-4660tvcjf93/Tmj019cVdyzEe9CsN2/r4krj1xdoBBY=";
  };

  patches = [
    # fwupdmgr is provided through NixOS' module
    (replaceVars ./0001-tool-paths.patch (
      {
        # @QtBinariesDir@ only appears in the *removed* lines of the diff
        QtBinariesDir = null;
      }
      // tools
    ))
  ];

  postPatch = ''
    substituteInPlace kcms/{firmware_security/fwupdmgr.sh,network/ip.sh} \
      --replace-fail " aha " " ${lib.getExe aha} "
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libusb1
    kauth
    kcmutils
    kcodecs
    kcompletion
    kconfig
    kcoreaddons
    ki18n
    kio
    kjobwidgets
    kservice
    kwindowsystem
    solid
  ];

  qtWrapperArgs = [ "--inherit-argv0" ];

  # fix wrong symlink of infocenter pointing to a 'systemsettings5' binary in
  # the same directory, while it is actually located in a completely different
  # store path
  preFixup = lib.optionalString (systemsettings != null) ''
    ln -sf ${systemsettings}/bin/systemsettings $out/bin/kinfocenter
  '';

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${lib.concatStringsSep ":" (lib.attrValues tools)}" > $out/nix-support/depends
  '';

  meta = {
    description = "A utility that provides information about a computer system";
    homepage = "https://invent.kde.org/plasma/kinfocenter";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kinfocenter";
  };
})
