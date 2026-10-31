{
  buildPerlPackage,
  fetchurl,
  lib,
  zlib,
}:
buildPerlPackage {
  pname = "PerlIO-gzip";
  version = "0.20";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz";
    hash = "sha256-SEhnmj8gHj87DF9vlSbmAq9Skj/6RxoqNlfbeGvTvcU=";
  };
  buildInputs = [ zlib ];
  env.NIX_CFLAGS_LINK = "-L${zlib.out}/lib -lz";
  meta = {
    description = "Perl extension to provide a PerlIO layer to gzip/gunzip";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
