{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLParser,
}:
buildPerlPackage {
  pname = "RPC-XML";
  version = "0.82";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.82.tar.gz";
    hash = "sha256-UnnrDRNsUz/4l/aTTDqtbyBQS5l/smBuUsXbvZJ1jnM=";
  };
  propagatedBuildInputs = [ XMLParser ];
  meta = {
    description = "Data, client and server classes for XML-RPC";
    homepage = "https://github.com/rjray/rpc-xml";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "make_method";
  };
}
