{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
}:
buildPerlPackage {
  pname = "Unicode-UTF8";
  version = "0.62";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHANSEN/Unicode-UTF8-0.62.tar.gz";
    hash = "sha256-+oci0LdGluMy/d1EKZRDbqk9O/x5gtS6vc7f3dZX0PY=";
  };

  buildInputs = [ TestFatal ];

  meta = {
    description = "Encoding and decoding of UTF-8 encoding form";
    homepage = "https://github.com/chansen/p5-unicode-utf8";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
