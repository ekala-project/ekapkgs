{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Env-Path";
  version = "0.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz";
    hash = "sha256-JEvwk3mIMqfYQdnuW0sOa0iZlu72NUHlBQkao0qQFeI=";
  };
  meta = {
    description = "Advanced operations on path variables";
  };
}
