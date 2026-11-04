{
  buildPerlPackage,
  fetchurl,
  CaptureTiny,
  IOAll,
  ModuleInstall,
  PodMarkdown,
}:
buildPerlPackage {
  pname = "Module-Install-ReadmeFromPod";
  version = "0.30";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Module-Install-ReadmeFromPod-0.30.tar.gz";
    hash = "sha256-efbfVTZhn6/72mlr3SXMrRfEab8y5RzT5hM2bUlAAWk=";
  };
  propagatedBuildInputs = [
    CaptureTiny
    IOAll
    ModuleInstall
    PodMarkdown
  ];
  meta = {
    description = "Module::Install extension to automatically convert POD to a README";
  };
}
