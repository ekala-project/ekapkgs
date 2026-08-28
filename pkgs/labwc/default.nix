{
  lib,
  cairo,
  fetchFromGitHub,
  gettext,
  glib,
  libdrm,
  libinput,
  libpng,
  librsvg,
  libsfdo,
  libxcb,
  libxkbcommon,
  libxml2,
  meson,
  ninja,
  pango,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  libxcb-wm,
  xwayland,

  # TODO: xwayland fails to build (libtirpc broken in corepkgs); disable until fixed
  enableXWayland ? false,
  enableSystemd ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    tag = finalAttrs.version;
    hash = "sha256-gKix9UW4np6fMoMZgHN9G4opwbPkT6ax5G5ZWQCzYio=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "install_dir: systemd.get_variable('systemduserunitdir')" \
                     "install_dir: '$out/lib/systemd/user'"
  '';

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libpng
    librsvg
    libsfdo
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    (wlroots.override { inherit enableXWayland; })
  ]
  ++ lib.optionals enableXWayland [
    libxcb-wm
    xwayland
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
    (lib.mesonEnable "systemd-session" enableSystemd)
  ];

  strictDeps = true;

  passthru = {
    providedSessions = [ "labwc" ];
  };

  meta = {
    homepage = "https://github.com/labwc/labwc";
    description = "Wayland stacking compositor, inspired by Openbox";
    changelog = "https://github.com/labwc/labwc/blob/master/NEWS.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "labwc";
    maintainers = [ ];
    inherit (wayland.meta) platforms;
  };
})
