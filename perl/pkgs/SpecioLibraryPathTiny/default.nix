{
  buildPerlPackage,
  fetchurl,
  lib,
  PathTiny,
  Specio,
  Filepushd,
  TestFatal,
}:
buildPerlPackage {
  pname = "Specio-Library-Path-Tiny";
  version = "0.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Specio-Library-Path-Tiny-0.05.tar.gz";
    hash = "sha256-YN8Lubza6yxmoHi/bfmVTqT5Qz1stoCImULlQsfCelE=";
  };

  propagatedBuildInputs = [
    PathTiny
    Specio
  ];

  buildInputs = [
    Filepushd
    TestFatal
  ];

  meta = {
    description = "Path::Tiny types and coercions for Specio";
    homepage = "https://metacpan.org/release/Specio-Library-Path-Tiny";
    license = lib.licenses.asl20;
  };
}
