{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Set-Infinite";
  version = "0.65";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FG/FGLOCK/Set-Infinite-0.65.tar.gz";
    hash = "sha256-B7yIBzRJLeQLSjqLWjMXYvZOabRikCn9mp01eyW4fh8=";
  };

  meta = {
    description = "Infinite Sets math";
  };
}
