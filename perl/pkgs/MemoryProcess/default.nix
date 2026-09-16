{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  TestNoWarnings,
  MemoryUsage,
  Readonly,
}:
buildPerlPackage {
  pname = "Memory-Process";
  version = "0.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SK/SKIM/Memory-Process-0.06.tar.gz";
    hash = "sha256-NYFEiP/SnJdiFiXqOz1wCvv6YO0FW9dZ1OWNnI/UTk4=";
  };
  buildInputs = [
    CaptureTiny
    TestNoWarnings
  ];
  propagatedBuildInputs = [
    MemoryUsage
    Readonly
  ];
  meta = {
    description = "Memory process reporting";
    homepage = "https://github.com/michal-josef-spacek/Memory-Process";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
