{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Locale-Maketext-Fuzzy";
  version = "0.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Fuzzy-0.11.tar.gz";
    hash = "sha256-N4UXHOt4zHZxMZo6bYztmxkOCX382bKp68gEzRooL5Y=";
  };
  meta = {
    description = "Maketext from already interpolated strings";
    license = lib.licenses.cc0;
  };
}
