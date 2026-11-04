{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  CryptRandomSeed,
  MathRandomISAAC,
}:
buildPerlPackage {
  pname = "Bytes-Random-Secure";
  version = "0.29";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAVIDO/Bytes-Random-Secure-0.29.tar.gz";
    hash = "sha256-U7vTOeahHvygfGGaYVx8GIpouyvoSaHLfvw91Nmuha4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-11625.patch";
      url = "https://security.metacpan.org/patches/B/Bytes-Random-Secure/0.29/CVE-2026-11625-r1.patch";
      hash = "sha256-EDPFvFjqGtN5/TiJlarqKMrtH6kEQD6rOA7B2moBkiA=";
    })
  ];

  propagatedBuildInputs = [
    CryptRandomSeed
    MathRandomISAAC
  ];

  meta = {
    description = "Perl extension to generate cryptographically-secure random bytes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
