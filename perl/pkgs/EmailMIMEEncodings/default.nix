{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
}:
buildPerlPackage {
  pname = "Email-MIME-Encodings";
  version = "1.317";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-Encodings-1.317.tar.gz";
    hash = "sha256-SppBZxqdFQTE2iQb5BmpUD+jSGJiUm7bgeyp4uvqC68=";
  };
  buildInputs = [ CaptureTiny ];
  meta = {
    description = "Unified interface to MIME encoding and decoding";
    homepage = "https://github.com/rjbs/Email-MIME-Encodings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
