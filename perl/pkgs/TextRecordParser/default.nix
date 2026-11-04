{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassAccessor,
  IOStringy,
  ListMoreUtils,
  Readonly,
  TextAutoformat,
  TestException,
}:
buildPerlPackage {
  pname = "Text-RecordParser";
  version = "1.6.5";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KC/KCLARK/Text-RecordParser-1.6.5.tar.gz";
    hash = "sha256-2juBQUxj+NkhjRFnRaiLlIxGyYsYdjT2KYkuVAAbw1o=";
  };

  # In a NixOS chroot build, the tests fail because the font configuration
  # at /etc/fonts/font.conf is not available.
  propagatedBuildInputs = [
    ClassAccessor
    IOStringy
    ListMoreUtils
    Readonly
    TextAutoformat
  ];

  buildInputs = [ TestException ];

  meta = {
    description = "Read record-oriented files";
    license = lib.licenses.gpl2Only;
  };
}
