{
  buildPerlPackage,
  fetchurl,
  xz,
}:
buildPerlPackage {
  pname = "Compress-Raw-Lzma";
  version = "2.206";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Lzma-2.206.tar.gz";
    hash = "sha256-4BpwQLhL3GdZLRPuwMeIWQ4faW0dTwfHCXvXKk+IbrQ=";
  };
  preConfigure = ''
    cat > config.in <<EOF
      INCLUDE      = ${xz.dev}/include
      LIB          = ${xz.out}/lib
    EOF
  '';
  meta = {
    description = "Low-Level Interface to lzma compression library";
  };
}
