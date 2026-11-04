{
  buildPerlPackage,
  fetchurl,
  lib,
  ListMoreUtils,
  Moose,
  TestFatal,
}:
buildPerlPackage {
  pname = "MooseX-NonMoose";
  version = "0.26";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.26.tar.gz";
    hash = "sha256-y75S7PFgOCMfvX8sxrzhZqNWnIyzlq6A7EUXwuCNqn0=";
  };

  buildInputs = [ TestFatal ];

  propagatedBuildInputs = [
    ListMoreUtils
    Moose
  ];

  meta = {
    description = "Easy subclassing of non-Moose classes";
    homepage = "https://metacpan.org/release/MooseX-NonMoose";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
