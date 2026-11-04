{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "String-Format";
  version = "1.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SR/SREZIC/String-Format-1.18.tar.gz";
    hash = "sha256-nkF6j42epiO+6i0TpHwNWmlvyGAsBQm4Js1F+Xt253g=";
  };
  meta = {
    description = "Sprintf-like string formatting capabilities with arbitrary format definitions";
    license = lib.licenses.gpl2Only;
  };

}
