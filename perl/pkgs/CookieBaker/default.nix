{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestTime,
  URI,
}:
buildPerlModule {
  pname = "Cookie-Baker";
  version = "0.12";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cookie-Baker-0.12.tar.gz";
    hash = "sha256-mwTfXUfc1FrEKZYmoQ7JkPtAyU7lpjAMOoi9+zV17Ck=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestTime
  ];

  propagatedBuildInputs = [ URI ];

  meta = {
    description = "Cookie string generator / parser";
    homepage = "https://github.com/kazeburo/Cookie-Baker";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
