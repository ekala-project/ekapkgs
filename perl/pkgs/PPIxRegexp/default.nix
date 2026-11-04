{
  buildPerlModule,
  fetchurl,
  lib,
  PPI,
}:
buildPerlModule {
  pname = "PPIx-Regexp";
  version = "0.088";

  src = fetchurl {
    url = "mirror://cpan/authors/id/W/WY/WYANT/PPIx-Regexp-0.088.tar.gz";
    hash = "sha256-iFQz+bEC+tT9NrIccyC7A2A2ERyvmYExv0FvfNXul2Q=";
  };

  propagatedBuildInputs = [ PPI ];

  meta = {
    description = "Parse regular expressions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
