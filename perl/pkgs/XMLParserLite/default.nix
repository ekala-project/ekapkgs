{
  buildPerlPackage,
  fetchurl,
  TestRequires,
}:
buildPerlPackage {
  pname = "XML-Parser-Lite";
  version = "0.722";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PH/PHRED/XML-Parser-Lite-0.722.tar.gz";
    hash = "sha256-b5CgJ+FTGg5UBs8d4Txwm1IWlm349z0Lq5q5GSCXY+4=";
  };
  buildInputs = [ TestRequires ];
  meta = {
    description = "Lightweight pure-perl XML Parser (based on regexps)";
  };
}
