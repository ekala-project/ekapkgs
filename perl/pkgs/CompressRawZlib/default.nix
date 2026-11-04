{
  buildPerlPackage,
  fetchurl,
  stdenv,
  lib,
  zlib,
}:
buildPerlPackage {
  pname = "Compress-Raw-Zlib";
  version = "2.222";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Zlib-2.222.tar.gz";
    hash = "sha256-Hf19URplVifIGBXTDTurwo+luIRV/wP4sECZ3LUShrg=";
  };

  preConfigure = ''
    cat > config.in <<EOF
      BUILD_ZLIB    = False
      ZLIB_INCLUDE  = ${zlib.dev}/include
      ZLIB_LIB      = ${zlib.out}/lib
      OLD_ZLIB      = False
      GZIP_OS_CODE  = AUTO_DETECT
      USE_ZLIB_NG   = False
    EOF
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Low-Level Interface to zlib or zlib-ng compression library";
    homepage = "https://github.com/pmqs/Compress-Raw-Zlib";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
