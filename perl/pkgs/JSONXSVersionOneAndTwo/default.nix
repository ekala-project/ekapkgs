{
  buildPerlPackage,
  fetchurl,
  lib,
  JSONXS,
}:
buildPerlPackage {

  pname = "JSON-XS-VersionOneAndTwo";
  version = "0.31";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LB/LBROCARD/JSON-XS-VersionOneAndTwo-0.31.tar.gz";
    hash = "sha256-5gksTZYfrnd6z3/pn7PNbltxD+yFdlprkEF0gOTJSjQ=";
  };
  propagatedBuildInputs = [ JSONXS ];
  meta = {
    description = "Support versions 1 and 2 of JSON::XS";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
