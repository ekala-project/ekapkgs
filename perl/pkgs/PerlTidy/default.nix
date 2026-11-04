{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Perl-Tidy";
  version = "20250711";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHANCOCK/Perl-Tidy-20250711.tar.gz";
    hash = "sha256-NHqpC8773itZDa9I04fvH9m3pzqZawQCafEatvuLpEg=";
  };

  meta = {
    description = "Indent and reformat perl scripts";
    license = lib.licenses.gpl2Plus;
    mainProgram = "perltidy";
  };
}
