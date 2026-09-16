{
  buildPerlPackage,
  fetchurl,
  lib,
  gettext,
}:
buildPerlPackage {
  pname = "gettext";
  version = "1.07";
  strictDeps = true;
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz";
    hash = "sha256-kJ1HlUaX58BCGPlykVt4e9EkTXXjvQFiC8Fn1bvEnBU=";
  };
  buildInputs = [ gettext ];
  env.LANG = "C";
  meta = {
    description = "Perl extension for emulating gettext-related API";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
