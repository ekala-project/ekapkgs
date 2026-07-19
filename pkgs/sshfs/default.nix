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

stdenv.mkDerivation rec {
  pname = "sshfs-fuse";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "0s2hilqixjmv4y8n67zaq374sgnbscp95lgz5ignp69g3p1vmhwz";
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
    wrapProgram $out/bin/sshfs --prefix PATH : "${openssh}/bin"
  '';

  meta = {
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    homepage = "https://github.com/libfuse/sshfs";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sshfs";
    maintainers = [ ];
  };
}
