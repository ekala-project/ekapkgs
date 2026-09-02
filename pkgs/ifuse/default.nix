{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3 ? null,
  usbmuxd ? null,
  libimobiledevice ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ifuse";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ifuse";
    tag = finalAttrs.version;
    hash = "sha256-STMELfxbWf2W6NKKqBxgbQLZpYXv9N0cDLgHho5PRYM=";
  };

  env = {
    VER = finalAttrs.version;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fuse3
    usbmuxd
    libimobiledevice
  ];

  meta = {
    homepage = "https://github.com/libimobiledevice/ifuse";
    description = "Fuse filesystem implementation to access the contents of iOS devices";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ifuse";
  };
})
