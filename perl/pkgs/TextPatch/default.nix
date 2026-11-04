{
  buildPerlPackage,
  fetchurl,
  lib,
  TextDiff,
}:
buildPerlPackage {
  pname = "Text-Patch";
  version = "1.8";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CADE/Text-Patch-1.8.tar.gz";
    hash = "sha256-6vGOYbpqPhQ4RqfMZvCM5YoMT72pKssxrt4lyztcPcw=";
  };

  propagatedBuildInputs = [ TextDiff ];

  meta = {
    description = "Patches text with given patch";
    license = lib.licenses.gpl2Only;
  };
}
