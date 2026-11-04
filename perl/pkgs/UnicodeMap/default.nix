{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Unicode-Map";
  version = "0.112";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSCHWARTZ/Unicode-Map-0.112.tar.gz";
    hash = "sha256-EPDC8S67pX3NT0bSTPJCwZFdMewKTsNrTfGMnKDLSlo=";
  };

  meta = {
    description = "Maps langstrings to corresponding unicode or vice versa";
  };
}
