{
  buildPerlModule,
  fetchurl,
  lib,
  Mojolicious,
}:
buildPerlModule {
  pname = "WebService-MusicBrainz";
  version = "1.0.6";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BF/BFAIST/WebService-MusicBrainz-1.0.6.tar.gz";
    hash = "sha256-XpH1ZZZ3w5CJv28lO0Eoe7zTVh9qJaB5Zc6DsmKIUuE=";
  };
  propagatedBuildInputs = [ Mojolicious ];
  doCheck = false;
  meta = {
    description = "API to search the musicbrainz.org database";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
