{
  buildPerlPackage,
  fetchurl,
  CaptureTiny,
}:
buildPerlPackage {
  pname = "Config-AutoConf";
  version = "0.320";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AM/AMBS/Config-AutoConf-0.320.tar.gz";
    hash = "sha256-u1epWO9J0/cWInba4Up71a9D/R2FEyMa811mVFlFQCM=";
  };
  propagatedBuildInputs = [ CaptureTiny ];
}
