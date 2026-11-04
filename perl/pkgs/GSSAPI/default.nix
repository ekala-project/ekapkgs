{
  buildPerlPackage,
  fetchurl,
  lib,
  libkrb5,
}:
buildPerlPackage {
  pname = "GSSAPI";
  version = "0.28";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AG/AGROLMS/GSSAPI-0.28.tar.gz";
    hash = "sha256-fY8se2F2L7TsctLsKBKQ8vh/nH0pgnPaRSVDKmXncNY=";
  };
  propagatedBuildInputs = [ libkrb5.dev ];
  makeMakerFlags = [
    "--gssapiimpl"
    "${libkrb5.dev}"
  ];
  meta = {
    description = "Perl extension providing access to the GSSAPIv2 library";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
