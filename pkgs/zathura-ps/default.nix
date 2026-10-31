{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  zathura_core ? null,
  girara,
  libspectre,
  gettext,
  desktop-file-utils,
  appstream,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-ps";
  version = "2026.02.03";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-ps";
    tag = finalAttrs.version;
    hash = "sha256-5i3LvdjcAdofc0oZCBSm2qn/29UR1Yiia3OmVjFC4ZI=";
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
    libspectre
    zathura_core
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-ps/";
    description = "Zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
