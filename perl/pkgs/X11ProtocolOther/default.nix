{
  buildPerlPackage,
  fetchurl,
  lib,
  X11Protocol,
  EncodeHanExtra,
  ModuleUtil,
}:
buildPerlPackage {
  pname = "X11-Protocol-Other";
  version = "31";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KR/KRYDE/X11-Protocol-Other-31.tar.gz";
    hash = "sha256-PGJZk9x6jrHQLgcQimZjAkWcb8b589J2FfdJUVjcc/Q=";
  };

  propagatedBuildInputs = [ X11Protocol ];

  buildInputs = [
    EncodeHanExtra
    ModuleUtil
  ];

  meta = {
    description = "Miscellaneous helpers for X11::Protocol connections";
    license = with lib.licenses; [
      gpl1Plus
      gpl3Plus
    ];
  };
}
