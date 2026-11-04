{
  buildPerlModule,
  fetchurl,
  lib,
  TextAligner,
}:
buildPerlModule {
  pname = "Text-Table";
  version = "1.135";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Table-1.135.tar.gz";
    hash = "sha256-/KPBboMSf3xE3ePT9+PHPqUNEJoQVERd6Agv6nlMpdI=";
  };

  propagatedBuildInputs = [ TextAligner ];

  meta = {
    description = "Organize Data in Tables";
    license = lib.licenses.isc;
  };
}
