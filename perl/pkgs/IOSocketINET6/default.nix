{
  buildPerlModule,
  fetchurl,
  Socket6,
}:
buildPerlModule {
  pname = "IO-Socket-INET6";
  version = "2.73";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.73.tar.gz";
    hash = "sha256-ttp0aFMlPVtKxDGRtPaaRxlZXuE6fKZ2qAVM825tFrs=";
  };
  propagatedBuildInputs = [ Socket6 ];
  doCheck = false;
  meta = {
    description = "[DEPRECATED] Object interface for AF_INET/AF_INET6 domain sockets";
  };
}
