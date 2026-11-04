{
  buildPerlPackage,
  fetchurl,
  lib,
  SubExporter,
  SubName,
  namespaceautoclean,
}:
buildPerlPackage {

  pname = "Sub-Exporter-ForMethods";
  version = "0.100055";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-ForMethods-0.100055.tar.gz";
    hash = "sha256-eR9CA7p8D32DgLwBvsICFffIvHDX7QPlUu7kRUGr6U4=";
  };
  buildInputs = [ namespaceautoclean ];
  propagatedBuildInputs = [
    SubExporter
    SubName
  ];
  meta = {
    description = "Helper routines for using Sub::Exporter to build methods";
    homepage = "https://github.com/rjbs/Sub-Exporter-ForMethods";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
