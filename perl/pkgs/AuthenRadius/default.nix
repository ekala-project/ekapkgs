{
  buildPerlPackage,
  fetchurl,
  lib,
  TestNoWarnings,
  DataHexDump,
  NetIP,
}:
buildPerlPackage {
  pname = "Authen-Radius";
  version = "0.32";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PO/PORTAONE/Authen-Radius-0.32.tar.gz";
    hash = "sha256-eyCPmDfIOhhCZyVIklNlh+7Qvd5J577euj1ypmUjF0A=";
  };
  buildInputs = [ TestNoWarnings ];
  propagatedBuildInputs = [
    DataHexDump
    NetIP
  ];
  meta = {
    description = "Provide simple Radius client facilities";
    license = lib.licenses.artistic2;
  };
}
