{
  buildPerlPackage,
  fetchurl,
  lib,
  PerlIOutf8_strict,
  SubExporter,
}:
buildPerlPackage {
  pname = "Mixin-Linewise";
  version = "0.111";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Mixin-Linewise-0.111.tar.gz";
    hash = "sha256-0o6IUWzptSlcMWMdzM3A/I8qt9ilzIdrsbIBMQh7Ads=";
  };

  propagatedBuildInputs = [
    PerlIOutf8_strict
    SubExporter
  ];

  meta = {
    description = "Write your linewise code for handles; this does the rest";
    homepage = "https://github.com/rjbs/Mixin-Linewise";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
