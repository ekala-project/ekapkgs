{
  buildPerlModule,
  fetchurl,
  lib,
  TestBase,
  TestDifferences,
}:
buildPerlModule {
  pname = "ExtUtils-XSpp";
  version = "0.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SM/SMUELLER/ExtUtils-XSpp-0.18.tar.gz";
    hash = "sha256-kXatZGcp470nz3q/EUvt00JL/xumEYXPx9VPOpIjqP8=";
  };
  buildInputs = [
    TestBase
    TestDifferences
  ];
  meta = {
    description = "XS for C++";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
