{
  lib,
  perlPackages,
  fetchurl,
}:

perlPackages.buildPerlPackage {
  pname = "MHonArc";
  version = "2.6.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LD/LDIDRY/MHonArc-2.6.24.tar.gz";
    hash = "sha256-RX3HN07lnLdaBynlHO8vLFK0gYD3Odj9lW6hmIKBXzM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  installTargets = [ "install" ];

  meta = {
    homepage = "https://www.mhonarc.org/";
    description = "Mail-to-HTML converter";
    mainProgram = "mhonarc";
    license = lib.licenses.gpl2Only;
  };
}
