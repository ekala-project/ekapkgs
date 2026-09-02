{
  lib,
  stdenv,
  fetchurl,
  boost,
  pkg-config,
  cppunit,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librevenge";
  version = "0.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/libwpd/librevenge/librevenge-${finalAttrs.version}/librevenge-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-EG0MRLtkCLE0i54EZWZvqDuBYXdmWiLNAX6IbBqu6zQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
  ];

  configureFlags = [ "--disable-werror" ];

  postPatch = ''
    sed -i 's,-DLIBREVENGE_BUILD,\0 -DBOOST_ERROR_CODE_HEADER_ONLY,g' src/lib/Makefile.in
  '';

  meta = {
    description = "Base library for writing document import filters";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
  };
})
