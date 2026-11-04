{
  buildPerlPackage,
  fetchurl,
  lib,
  TryTiny,
  DataSection,
  TextTemplate,
}:
buildPerlPackage {
  pname = "Software-License";
  version = "0.104004";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Software-License-0.104004.tar.gz";
    hash = "sha256-of2iTsh3UhmAlzgPuTAMFLV0gmJwzFgNr3UONYX8Jww=";
  };
  buildInputs = [ TryTiny ];
  propagatedBuildInputs = [
    DataSection
    TextTemplate
  ];
  meta = {
    description = "Packages that provide templated software licenses";
    homepage = "https://github.com/Perl-Toolchain-Gang/Software-License";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
