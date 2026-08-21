{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  runtimeShell,
  systemdSupport ? false,
  systemdLibs ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swayidle";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fxDwRfAXb9D6epLlyWnXpy9g8V3ovJRpQ/f3M4jxY/s=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals (systemdSupport && systemdLibs != null) [ systemdLibs ];

  mesonFlags = [
    "-Dman-pages=enabled"
    "-Dlogind=${if systemdSupport then "enabled" else "disabled"}"
  ];

  postPatch = ''
    substituteInPlace main.c \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  meta = {
    description = "Idle management daemon for Wayland";
    homepage = "https://github.com/swaywm/swayidle";
    license = lib.licenses.mit;
    mainProgram = "swayidle";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
