{
  buildPerlPackage,
  fetchurl,
  lib,
  DigestSHA1,
  URI,
}:
buildPerlPackage {
  pname = "Razor2-Client-Agent";
  version = "2.86";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TODDR/Razor2-Client-Agent-2.86.tar.gz";
    hash = "sha256-XgYuAuu2XiS3COfu+lMAxD1vZXvyDQj+xMqKCjuUhF8=";
  };

  propagatedBuildInputs = [
    DigestSHA1
    URI
  ];

  meta = {
    description = "Collaborative, content-based spam filtering network agent";
    homepage = "https://razor.sourceforge.net/";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
