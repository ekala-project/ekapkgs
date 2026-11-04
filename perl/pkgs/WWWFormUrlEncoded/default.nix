{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "WWW-Form-UrlEncoded";
  version = "0.26";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/WWW-Form-UrlEncoded-0.26.tar.gz";
    hash = "sha256-wEgLXx8VtxFj7DJ7jnhCKY8Ms6zpfmPXA0rx6UotkPQ=";
  };
  meta = {
    description = "Parser and builder for application/x-www-form-urlencoded";
    homepage = "https://github.com/kazeburo/WWW-Form-UrlEncoded";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
