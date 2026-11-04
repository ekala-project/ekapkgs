{
  buildPerlPackage,
  fetchurl,
  lib,
  TestNeeds,
  SubIdentify,
  namespaceclean,
}:
buildPerlPackage {
  pname = "namespace-autoclean";
  version = "0.29";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz";
    hash = "sha256-RevY5kpUqG+I2OAa5VISlnyKqP7VfoFAhd73YIrGWAQ=";
  };

  buildInputs = [ TestNeeds ];

  propagatedBuildInputs = [
    SubIdentify
    namespaceclean
  ];

  meta = {
    description = "Keep imports out of your namespace";
    homepage = "https://github.com/moose/namespace-autoclean";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
