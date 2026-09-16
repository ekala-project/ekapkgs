{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLParser,
}:
buildPerlPackage {
  pname = "Devel-Cover";
  version = "1.44";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PJ/PJCJ/Devel-Cover-1.44.tar.gz";
    hash = "sha256-9AwVQ5kuXWWm94AD1GLVms15rm0w04BHscadmZ0rH9g=";
  };
  propagatedBuildInputs = [ HTMLParser ];
  doCheck = false;
  meta = {
    description = "Code coverage metrics for Perl";
    homepage = "https://www.pjcj.net/perl.html";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
