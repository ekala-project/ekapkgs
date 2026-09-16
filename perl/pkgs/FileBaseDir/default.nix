{
  buildPerlPackage,
  fetchurl,
  IPCSystemSimple,
  FileWhich,
}:
buildPerlPackage {
  version = "0.09";
  pname = "File-BaseDir";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PL/PLICEASE/File-BaseDir-0.09.tar.gz";
    hash = "sha256-bab3KBVirI8R7xo69q7bUcQRgrYPHxIs7QB579kpZ9k=";
  };
  propagatedBuildInputs = [ IPCSystemSimple ];
  nativeCheckInputs = [ FileWhich ];
  meta = {
    description = "Use the Freedesktop.org base directory specification";
  };
}
