{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "XML-SAX-Base";
  version = "1.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz";
    hash = "sha256-Zss1W6TvR8EMpzi9NZmXI2RDhqyFOrvrUTKEH16KKtA=";
  };
  meta = {
    description = "Base class for SAX Drivers and Filters";
    homepage = "https://github.com/grantm/XML-SAX-Base";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
