{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTime,
}:
buildPerlPackage {
  pname = "DateTime-Format-W3CDTF";
  version = "0.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GW/GWILLIAMS/DateTime-Format-W3CDTF-0.08.tar.gz";
    hash = "sha256-3MIAoHOiHLpIEipdrgtqh135PT+MiunURtzdm++qQTo=";
  };
  propagatedBuildInputs = [ DateTime ];
  meta = {
    description = "Parse and format W3CDTF datetime strings";
    homepage = "https://metacpan.org/release/DateTime-Format-W3CDTF";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
