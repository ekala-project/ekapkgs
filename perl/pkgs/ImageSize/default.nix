{
  buildPerlPackage,
  fetchurl,
  ModuleBuild,
}:
buildPerlPackage {
  pname = "Image-Size";
  version = "3.300";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJRAY/Image-Size-3.300.tar.gz";
    hash = "sha256-U8mx+GUxzeBg7mNwnR/ac8q8DPLVgdKbIrAUeBufAms=";
  };
  buildInputs = [ ModuleBuild ];
  meta = {
    description = "Library to extract height/width from images";
  };
}
