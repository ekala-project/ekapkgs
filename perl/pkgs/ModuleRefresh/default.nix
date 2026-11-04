{
  buildPerlPackage,
  fetchurl,
  lib,
  PathClass,
}:
buildPerlPackage {
  pname = "Module-Refresh";
  version = "0.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/Module-Refresh-0.18.tar.gz";
    hash = "sha256-4JTaqQmv32SJqeKzJzP2haLBy1zIh2BhB1SGEJsN71k=";
  };
  buildInputs = [ PathClass ];
  meta = {
    description = "Refresh %INC files when updated on disk";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
