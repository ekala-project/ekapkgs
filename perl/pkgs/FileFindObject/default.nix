{
  buildPerlModule,
  fetchurl,
  lib,
  FileTreeCreate,
  TestFile,
  ClassXSAccessor,
}:
buildPerlModule {
  pname = "File-Find-Object";
  version = "0.3.8";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-0.3.8.tar.gz";
    hash = "sha256-TlJRRt6GTt+8kJsIRGKe7O0AY7YdQYuXLu8D+ES7NRQ=";
  };

  buildInputs = [
    FileTreeCreate
    TestFile
  ];

  propagatedBuildInputs = [ ClassXSAccessor ];

  meta = {
    description = "Object oriented File::Find replacement";
    homepage = "https://metacpan.org/release/File-Find-Object";
    license = lib.licenses.artistic2;
  };
}
