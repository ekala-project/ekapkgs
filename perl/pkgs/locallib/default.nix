{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleBuild,
}:
buildPerlPackage {
  pname = "local-lib";
  version = "2.000029";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/local-lib-2.000029.tar.gz";
    hash = "sha256-jfh6EMFMjpCcW0fFcB5LgYfVGeUlHofIBwmwK7M+/dc=";
  };

  propagatedBuildInputs = [ ModuleBuild ];

  meta = {
    description = "Create and use a local lib/ for perl modules with PERL5LIB";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
