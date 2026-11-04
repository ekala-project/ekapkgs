{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "prefork";
  version = "1.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/prefork-1.05.tar.gz";
    hash = "sha256-bYe836Y7KM78+ocIA6UZtlkOPqGcMA+YzssOGQuxkwU=";
  };

  meta = {
    description = "Optimized module loading for forking or non-forking processes";
    homepage = "https://github.com/karenetheridge/prefork";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
