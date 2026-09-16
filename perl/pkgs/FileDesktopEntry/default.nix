{
  buildPerlPackage,
  fetchurl,
  FileBaseDir,
  URI,
}:
buildPerlPackage {
  version = "0.22";
  pname = "File-DesktopEntry";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MICHIELB/File-DesktopEntry-0.22.tar.gz";
    hash = "sha256-FpwB49ri9il2e+wanxzb1uxtcT0VAeCyeG5N0SNWNbg=";
  };
  propagatedBuildInputs = [
    FileBaseDir
    URI
  ];
  meta = {
    description = "Object to handle .desktop files";
  };
}
