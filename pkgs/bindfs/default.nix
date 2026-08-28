{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  fuse3 ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.18.1";
  pname = "bindfs";

  src = fetchurl {
    url = "https://bindfs.org/downloads/bindfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-KnBk2ZOl8lXFLXI4XvFONJwTG8RBlXZuIXNCjgbSef0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mpartel/bindfs/commit/3293dc98e37eed0fb0cbfcbd40434d3c37c69480.patch";
      hash = "sha256-dtjvSJTS81R+sksl7n1QiyssseMQXPlm+LJYZ8/CESQ=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals (fuse3 != null) [ fuse3 ];

  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    changelog = "https://github.com/mpartel/bindfs/raw/${finalAttrs.version}/ChangeLog";
    description = "FUSE filesystem for mounting a directory to another location";
    homepage = "https://bindfs.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
