{
  fetchurl,
  lib,
  stdenv,
  zlib,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tokyocabinet";
  version = "1.4.48";

  src = fetchurl {
    url = "https://dbmx.net/tokyocabinet/tokyocabinet-${finalAttrs.version}.tar.gz";
    sha256 = "140zvr0n8kvsl0fbn2qn3f2kh3yynfwnizn4dgbj47m975yg80x0";
  };

  buildInputs = [
    zlib
    bzip2
  ];

  postInstall = ''
    sed -i "$out/lib/pkgconfig/tokyocabinet.pc" \
      -e 's|-lz|-L${zlib.out}/lib -lz|g;
          s|-lbz2|-L${bzip2.out}/lib -lbz2|g'
  '';

  meta = {
    description = "Tokyo Cabinet: a modern implementation of DBM";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
