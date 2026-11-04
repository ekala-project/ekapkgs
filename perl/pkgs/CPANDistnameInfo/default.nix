{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "CPAN-DistnameInfo";
  version = "0.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GB/GBARR/CPAN-DistnameInfo-0.12.tar.gz";
    hash = "sha256-LyT76ffurLwmnTX8YWGDIvwXvkme4M2QGPNwk0qfJDU=";
  };
  meta = {
    description = "Extract distribution name and version from a distribution filename";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
