{
  buildPerlPackage,
  fetchurl,
  lib,
  MixinLinewise,
}:
buildPerlPackage {
  pname = "Config-INI";
  version = "0.029";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Config-INI-0.029.tar.gz";
    hash = "sha256-C755enMCEGRKkH2QzUqisjrVgMsnvTk5O/xqfvn9/eo=";
  };

  propagatedBuildInputs = [ MixinLinewise ];

  meta = {
    description = "Simple .ini-file format";
    homepage = "https://github.com/rjbs/Config-INI";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
