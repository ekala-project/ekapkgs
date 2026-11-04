{
  buildPerlPackage,
  fetchurl,
  lib,
  Plack,
}:
buildPerlPackage {
  pname = "Plack-Middleware-ReverseProxy";
  version = "0.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ReverseProxy-0.16.tar.gz";
    hash = "sha256-h0kx030HZnug0PN5A7lFEQcfQZH+tz+kV2XaK4wVoSg=";
  };

  propagatedBuildInputs = [ Plack ];

  meta = {
    description = "Supports app to run as a reverse proxy backend";
    homepage = "https://github.com/lopnor/Plack-Middleware-ReverseProxy";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
