{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  help2man,
  lz4,
  lzo,
  which,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squashfs";
  version = "4.7.5";

  src = fetchFromGitHub {
    owner = "plougher";
    repo = "squashfs-tools";
    rev = finalAttrs.version;
    hash = "sha256-rQ69sXvi6wY8yRyuQzcJZ6MvVGBbIw7vG+kYVHvfQQ8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/plougher/squashfs-tools/commit/f88f4a659d6ab432a57e90fe2f6191149c6b343f.patch";
      hash = "sha256-XRDV6qtd5jVwt2jbIlLDYKiI1tbVcuij5/vaPj9SN5w=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    which
    help2man
  ];

  buildInputs = [
    zlib
    xz
    zstd
    lz4
    lzo
  ];

  preBuild = ''
    cd squashfs-tools
  '';

  installFlags = [
    "INSTALL_DIR=${placeholder "out"}/bin"
    "INSTALL_MANPAGES_DIR=${placeholder "out"}/share/man/man1"
  ];

  makeFlags = [
    "XZ_SUPPORT=1"
    "ZSTD_SUPPORT=1"
    "LZ4_SUPPORT=1"
    "LZMA_XZ_SUPPORT=1"
    "LZO_SUPPORT=1"
  ];

  meta = {
    homepage = "https://github.com/plougher/squashfs-tools";
    description = "Tool for creating and unpacking squashfs filesystems";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "mksquashfs";
  };
})
