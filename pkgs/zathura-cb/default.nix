{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  zathura_core ? null,
  girara,
  gettext,
  libarchive,
  desktop-file-utils,
  appstream,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
  version = "2026.05.10";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-cb";
    tag = finalAttrs.version;
    hash = "sha256-rSRUNPmmAXmxarAE+y4cwfvAZ9AajeaWLWoRFo5DZ7M=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream
    appstream-glib
  ];

  buildInputs = [
    libarchive
    zathura_core
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-cb/";
    description = "Zathura CB plugin";
    longDescription = ''
      The zathura-cb plugin adds comic book support to zathura.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
