{
  buildPerlPackage,
  fetchurl,
  lib,
  geoip,
}:
buildPerlPackage {
  pname = "Geo-IP";
  version = "1.51";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MAXMIND/Geo-IP-1.51.tar.gz";
    hash = "sha256-FjAgMV1cVEGDaseeCKd7Qo8nf9CQvqT6gNpwd7JDaro=";
  };

  makeMakerFlags = [
    "LIBS=-L${geoip}/lib"
    "INC=-I${geoip}/include"
  ];

  doCheck = false; # seems to access the network

  meta = {
    description = "Look up location and network information by IP Address";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
