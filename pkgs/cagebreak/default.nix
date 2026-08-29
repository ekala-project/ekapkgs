{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  fontconfig,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  libxcb-wm,
  makeWrapper,
  meson,
  ninja,
  pango,
  pixman,
  pkg-config,
  scdoc,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
  withXwayland ? true,
  xwayland,
  wlroots,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cagebreak";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = "cagebreak";
    tag = finalAttrs.version;
    hash = "sha256-MnavSWvYuiyQP+sIFnlU4647oemqe0bTiJF5W0vRq/U=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    fontconfig
    libdrm
    libevdev
    libinput
    libxkbcommon
    libxcb-wm
    pango
    pixman
    systemd
    wayland
    wayland-protocols
    (wlroots.override { enableXWayland = withXwayland; })
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Dman-pages=true"
    "-Dversion_override=${finalAttrs.version}"
    "-Dxwayland=${lib.boolToString withXwayland}"
  ];

  postPatch = ''
    sed -i -e 's|<drm_fourcc.h>|<libdrm/drm_fourcc.h>|' *.c

    sed -i "s|/etc/xdg/cagebreak|$out/share/cagebreak|" meson.build cagebreak.c
    substituteInPlace meson.build \
      --replace "/usr/share/licenses" "$out/share/licenses"
  '';

  postFixup = lib.optionalString withXwayland ''
    wrapProgram $out/bin/cagebreak \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = {
    homepage = "https://github.com/project-repo/cagebreak";
    description = "Wayland tiling compositor inspired by ratpoison";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/project-repo/cagebreak/blob/${finalAttrs.version}/Changelog.md";
    mainProgram = "cagebreak";
  };
})
