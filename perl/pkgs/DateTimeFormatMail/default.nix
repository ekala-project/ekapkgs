{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTime,
  ParamsValidate,
}:
buildPerlPackage {
  pname = "DateTime-Format-Mail";
  version = "0.403";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BO/BOOK/DateTime-Format-Mail-0.403.tar.gz";
    hash = "sha256-jfjjXER3OI/1x86LPotq5O0wIJx6UFHUFze9FNdV/LA=";
  };

  propagatedBuildInputs = [
    DateTime
    ParamsValidate
  ];

  meta = {
    description = "Convert between DateTime and RFC2822/822 formats";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
