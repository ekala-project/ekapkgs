{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-Iconv";
  version = "1.7";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz";
    hash = "sha256-W4C31ecJ00OTvLqIlxhkoXtEpb8PnkvO44PQKefS1cM=";
  };

  meta = {
    description = "Perl interface to iconv() codeset conversion function";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
