{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Sys-MemInfo";
  version = "0.99";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SC/SCRESTO/Sys-MemInfo-0.99.tar.gz";
    hash = "sha256-B4YxnTo6i65dcnk5JEvxfhQLcU9Sc01en2JyA+TPPjs=";
  };

  meta = {
    description = "Memory information";
    license = lib.licenses.gpl2Plus;
  };
}
