{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "UNIVERSAL-can";
  version = "1.20140328";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz";
    hash = "sha256-Ui2p8nR4b+LLqZvHfMHIHSFhlHkD1/rRC9Yt+38RmQ8=";
  };
  meta = {
    description = "Work around buggy code calling UNIVERSAL::can() as a function";
  };
}
