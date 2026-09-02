{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  docutils,
  makeWrapper,
  fuse3,
  glib,
  openssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sshfs-fuse";
  version = "3.7.6";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    tag = "sshfs-${finalAttrs.version}";
    hash = "sha256-BT9qttXyryliR2kV1xVYvcwJhB6gkGf7IEwrTB38SvI=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    docutils
    makeWrapper
  ];

  buildInputs = [
    fuse3
    glib
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.system == "i686-linux"
  ) "-D_FILE_OFFSET_BITS=64";

  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/sshfs --prefix PATH : "${openssh}/bin"
  '';

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    homepage = "https://github.com/libfuse/sshfs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sshfs";
  };
})
