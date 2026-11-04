{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTimeFormatBuilder,
  Test2Suite,
}:
buildPerlPackage {
  pname = "DateTime-Format-ISO8601";
  version = "0.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ISO8601-0.16.tar.gz";
    hash = "sha256-WChH9uApBlM0oAVk8gzXwo9OXNTsIVE9D2klMe07VuE=";
  };

  propagatedBuildInputs = [ DateTimeFormatBuilder ];

  buildInputs = [ Test2Suite ];

  meta = {
    description = "Parses ISO8601 formats";
    homepage = "https://metacpan.org/release/DateTime-HiRes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
