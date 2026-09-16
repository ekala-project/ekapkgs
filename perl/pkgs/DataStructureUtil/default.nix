{
  buildPerlPackage,
  fetchurl,
  TestPod,
}:
buildPerlPackage {
  pname = "Data-Structure-Util";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AN/ANDYA/Data-Structure-Util-0.16.tar.gz";
    hash = "sha256-nNQqE+ZcsV86diluuaE02iIBaOx0fFaNMxpQrnot28Y=";
  };
  buildInputs = [ TestPod ];
  meta = {
    description = "Change nature of data within a structure";
  };
}
