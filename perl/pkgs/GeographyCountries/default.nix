{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Geography-Countries";
  version = "2009041301";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AB/ABIGAIL/Geography-Countries-2009041301.tar.gz";
    hash = "sha256-SMQuQOgoG6fJgXQ6hUxI5t7y1R6wkl6myW4lx0SX8g8=";
  };

  meta = {
    description = "2-letter, 3-letter, and numerical codes for countries";
  };
}
