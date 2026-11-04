{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Class-Factory-Util";
  version = "1.7";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Class-Factory-Util-1.7.tar.gz";
    hash = "sha256-bFFrRFtE+HNj+zoUhDHTHp7LXm8h+2SByJskBrZpLiY=";
  };

  meta = {
    description = "Provide utility methods for factory classes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
