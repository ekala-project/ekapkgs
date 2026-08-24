{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  mount,
  libuuid,
  kmod,
  libgcrypt,
  gnutls,
  crypto ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntfs3g";
  version = "2026.7.7";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "tuxera";
    repo = "ntfs-3g";
    tag = finalAttrs.version;
    hash = "sha256-7Z3rMOHBwrWqkxeksic3+Z+WvwJy2ra9rRxGjESsd04=";
  };

  buildInputs = [
    gettext
    libuuid
  ]
  ++ lib.optionals crypto [
    gnutls
    libgcrypt
  ];

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt
    pkg-config
  ];

  patches = [
    ./autoconf-sbin-helpers.patch
    ./consistent-sbindir-usage.patch
  ];

  configureFlags = [
    "--disable-ldconfig"
    "--exec-prefix=\${prefix}"
    "--enable-mount-helper"
    "--enable-posix-acls"
    "--enable-xattr-mappings"
    "--${if crypto then "enable" else "disable"}-crypto"
    "--enable-extras"
    "--with-mount-helper=${lib.getExe' mount "mount"}"
    "--with-umount-helper=${lib.getExe' mount "umount"}"
    "--with-fuse=internal"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--with-modprobe-helper=${lib.getExe' kmod "modprobe"}"
  ];

  postInstall = ''
    ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/tuxera/ntfs-3g";
    description = "FUSE-based NTFS driver with full write support";
    mainProgram = "ntfs-3g";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = [ ];
  };
})
