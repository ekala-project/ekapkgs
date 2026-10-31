{
  buildPerlModule,
  fetchurl,
  lib,
  DateTime,
  HTTPDate,
}:
buildPerlModule {
  pname = "DateTime-Format-HTTP";
  version = "0.42";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CK/CKRAS/DateTime-Format-HTTP-0.42.tar.gz";
    hash = "sha256-0E52nfRZaN/S0b3GR6Mlxod2FAaXYnhubxN/H17D2EA=";
  };
  propagatedBuildInputs = [
    DateTime
    HTTPDate
  ];
  meta = {
    description = "Date conversion routines";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
