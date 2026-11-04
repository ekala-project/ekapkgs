{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Set-Object";
  version = "1.42";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/Set-Object-1.42.tar.gz";
    hash = "sha256-0YxaiiM+q70CBs89pbAPzdezf+vxKpPcw9HAJub97EU=";
  };
  meta = {
    description = "Unordered collections (sets) of Perl Objects";
    license = lib.licenses.artistic2;
  };
}
