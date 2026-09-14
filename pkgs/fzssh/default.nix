{
  lib,
  stdenv,
  fetchurl,
  libargon2,
  libfilezilla,
  meson,
  nettle,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fzssh";
  version = "1.3.0";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/packages/fzssh/fzssh-${finalAttrs.version}.tar.xz";
    hash = "sha256-hkWCsgNyZYi1oW2GFB/5Wrd9I5l2L+u+H97ZLk8EeZY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libargon2
    libfilezilla
    nettle
  ];

  meta = {
    homepage = "https://lib.filezilla-project.org/";
    description = "SSH/SFTP library based on libfilezilla";
    license = lib.licenses.gpl3Plus;
  };
})
