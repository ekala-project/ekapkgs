{
  buildPerlModule,
  fetchurl,
  DataDump,
}:
buildPerlModule {
  pname = "Test-Trap";
  version = "0.3.5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.3.5.tar.gz";
    hash = "sha256-VPmQFlYrWx1yEQEA8fK+Q3F4zfhDdvSV/9A3bx1+y5o=";
  };
  propagatedBuildInputs = [ DataDump ];
  meta = {
    description = "Trap exit codes, exceptions, output, etc";
  };
}
