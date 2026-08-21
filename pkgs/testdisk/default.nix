{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  libuuid,
  pkg-config,
  libjpeg,
  zlib,
  enableNtfs ? !stdenv.hostPlatform.isDarwin,
  ntfs3g ? null,
  enableExtFs ? !stdenv.hostPlatform.isDarwin,
  e2fsprogs ? null,
}:

assert enableNtfs -> ntfs3g != null;
assert enableExtFs -> e2fsprogs != null;

stdenv.mkDerivation rec {
  pname = "testdisk";
  version = "7.1";

  src = fetchurl {
    url = "https://www.cgsecurity.org/testdisk-${version}.tar.bz2";
    sha256 = "1zlh44w67py416hkvw6nrfmjickc2d43v51vcli5p374d5sw84ql";
  };

  patches = [
    ./gcc-14-fixes.diff
  ];

  enableParallelBuilding = true;

  buildInputs = [
    ncurses
    libuuid
    libjpeg
    zlib
  ]
  ++ lib.optional enableNtfs ntfs3g
  ++ lib.optional enableExtFs e2fsprogs;

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-Wno-unused";

  meta = with lib; {
    homepage = "https://www.cgsecurity.org/wiki/Main_Page";
    downloadPage = "https://www.cgsecurity.org/wiki/TestDisk_Download";
    description = "Data recovery utilities";
    longDescription = ''
      TestDisk is a powerful free data recovery software. It was primarily
      designed to help recover lost partitions and/or make non-booting disks
      bootable again when these symptoms are caused by faulty software: certain
      types of viruses or human error (such as accidentally deleting a
      Partition Table).

      PhotoRec is a file data recovery software designed to recover lost files
      including video, documents and archives from hard disks, CD-ROMs, and
      lost pictures (thus the Photo Recovery name) from digital camera memory.
      PhotoRec ignores the file system and goes after the underlying data, so
      it will still work even if your media's file system has been severely
      damaged or reformatted.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
