{
  buildPerlPackage,
  fetchurl,
  FileRemove,
  ModuleBuild,
  ModuleScanDeps,
  YAMLTiny,
}:
buildPerlPackage {
  pname = "Module-Install";
  version = "1.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Install-1.21.tar.gz";
    hash = "sha256-+/kQB/MFZfOSDhBgVf0NQoeYHV59rYs1MjzktzPxWns=";
  };
  propagatedBuildInputs = [
    FileRemove
    ModuleBuild
    ModuleScanDeps
    YAMLTiny
  ];
  meta = {
    description = "Standalone, extensible Perl module installer";
  };
}
