{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "BSD-Resource";
  version = "1.2911";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JH/JHI/BSD-Resource-1.2911.tar.gz";
    hash = "sha256-nRz7oGPMGPckJ6IkUfeQiDa3MxrIeF2+B1U8WwQ6DD0=";
  };
  meta = {
    description = "BSD process resource limit and priority functions";
    license = lib.licenses.artistic2;
  };
}
