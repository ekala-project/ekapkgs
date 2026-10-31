{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Set-Scalar";
  version = "1.29";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz";
    hash = "sha256-o9wVJvPd5y08ZOoAAHuGzmCM3Nk1Z89ubkLcEP3EUR0=";
  };
  meta = {
    description = "Basic set operations";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
