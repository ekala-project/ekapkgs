{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
}:
buildPerlPackage {
  pname = "Devel-CheckLib";
  version = "1.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz";
    hash = "sha256-hp04wljmRtzvZ2YJ8N18qQ8IX1bPb9cAGwGaXVuDH8o=";
  };

  buildInputs = [
    CaptureTiny
  ];

  meta = {
    description = "Check that a library is available";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
