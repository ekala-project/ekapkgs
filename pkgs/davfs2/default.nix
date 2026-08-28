{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  neon,
  procps,
  zlib,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "davfs2";
  version = "1.7.3";

  src = fetchurl {
    url = "mirror://savannah/davfs2/davfs2-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-pTaBYetQVWUdfl6BgMFgbaleeMlBtruKkobfeSPPy6k=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    zlib
  ];

  patches = [
    ./fix-sysconfdir.patch
    ./disable-suid.patch
    ./0001-umount_davfs-substitute-ps-command.patch
    ./0002-Make-sure-that-the-setuid-wrapped-umount-is-invoked.patch
  ];

  postPatch = ''
    substituteInPlace src/umount_davfs.c \
      --replace-fail '@ps@' '${procps}/bin/ps'
    substituteInPlace src/dav_fuse.c \
      --replace-fail '@wrapperDir@' '${wrapperDir}'
    substituteInPlace src/umount_davfs.c \
      --replace-fail '@wrapperDir@' '${wrapperDir}'
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-neon=${lib.getLib neon}"
  ];

  meta = {
    homepage = "https://savannah.nongnu.org/projects/davfs2";
    description = "Mount WebDAV shares like a typical filesystem";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
