{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-TabularDisplay";
  version = "1.38";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DARREN/Text-TabularDisplay-1.38.tar.gz";
    hash = "sha256-6wmQ+vpWtmfyPbdkvdpaTcX0sd3EsTg6pe7W8i7Rhug=";
  };
  meta = {
    description = "Display text in formatted table output";
    license = lib.licenses.gpl2Plus;
  };
}
