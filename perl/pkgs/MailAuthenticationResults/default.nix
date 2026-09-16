{
  buildPerlPackage,
  fetchurl,
  TestException,
  Clone,
  JSON,
}:
buildPerlPackage {
  pname = "Mail-AuthenticationResults";
  version = "2.20230112";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MB/MBRADSHAW/Mail-AuthenticationResults-2.20230112.tar.gz";
    hash = "sha256-wtFEyuAiX4vJ0PX60cPxOdJ89TT85+rHB2T79m/SI0E=";
  };
  buildInputs = [ TestException ];
  propagatedBuildInputs = [
    Clone
    JSON
  ];
  meta = {
    description = "Object Oriented Authentication-Results Headers";
  };
}
