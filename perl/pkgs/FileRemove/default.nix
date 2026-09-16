{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "File-Remove";
  version = "1.61";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz";
    hash = "sha256-/YV/WFkI/FA0YbnkizyFlOZTV2a8FL6xfJC6WNXcSXU=";
  };
  meta = {
    description = "Remove files and directories";
  };
}
