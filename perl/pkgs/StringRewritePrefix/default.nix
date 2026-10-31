{
  buildPerlPackage,
  fetchurl,
  lib,
  SubExporter,
}:
buildPerlPackage {
  pname = "String-RewritePrefix";
  version = "0.009";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.009.tar.gz";
    hash = "sha256-RJGL7JalSvjKN8qJfkNnCewoSgeyhRbvPM5GZoaWRtU=";
  };
  propagatedBuildInputs = [ SubExporter ];
  meta = {
    description = "Rewrite strings based on a set of known prefixes";
    homepage = "https://github.com/rjbs/String-RewritePrefix";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
