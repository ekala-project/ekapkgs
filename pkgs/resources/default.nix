{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  addDriverRunpath,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  gtk4,
  glib,
  libadwaita,
  dmidecode,
  util-linux,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resources";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BkyWq3Cwt34lNQ/p1iQcfIlkCefE2YeiQMd1T6ODbxw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zzSqwc+MoYoieOT0qmgfxKG8/HLGTVsTgcru5wZgn2M=";
  };

  nativeBuildInputs = [
    appstream-glib
    addDriverRunpath
    desktop-file-utils
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk4.wrapGAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  runtimeDeps = [
    dmidecode
    util-linux
    systemd
  ];

  mesonEntries = {
    profile = "default";
  };

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps})
  '';

  meta = {
    description = "Monitor your system resources and processes";
    homepage = "https://github.com/nokyan/resources";
    license = lib.licenses.gpl3Only;
    mainProgram = "resources";
    platforms = lib.platforms.linux;
  };
})
