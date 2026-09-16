{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "libintl-perl";
  version = "1.33";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.33.tar.gz";
    hash = "sha256-USbtqczQ7rENuC3e9jy8r329dx54zA+xEMw7WmuGeec=";
  };
  meta = {
    description = "Portable l10n and i10n functions";
    license = lib.licenses.gpl3Only;
  };
}
