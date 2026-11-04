{
  buildPerlPackage,
  fetchurl,
  lib,
  GD,
}:
buildPerlPackage {
  pname = "GDTextUtil";
  version = "0.86";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MV/MVERB/GDTextUtil-0.86.tar.gz";
    hash = "sha256-iG7L+Fz+lPQTXuVonEhHqa54PsuZ5nWeEsc08t1hFrw=";
  };

  propagatedBuildInputs = [ GD ];

  meta = {
    description = "Text utilities for use with GD";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
