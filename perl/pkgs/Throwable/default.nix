{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelStackTrace,
  Moo,
}:
buildPerlPackage {
  pname = "Throwable";
  version = "1.001";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Throwable-1.001.tar.gz";
    hash = "sha256-0MtenX0G1w8sxW7s+FeoOkXqykOFDc3akdP+tN3eTFE=";
  };

  propagatedBuildInputs = [
    DevelStackTrace
    Moo
  ];

  meta = {
    description = "Role for classes that can be thrown";
    homepage = "https://github.com/rjbs/Throwable";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
