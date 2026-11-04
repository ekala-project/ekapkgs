{
  buildPerlPackage,
  fetchurl,
  lib,
  gmp,
  DevelChecklib,
  TestRequires,
}:
buildPerlPackage {
  pname = "Crypt-DH-GMP";
  version = "0.00012";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DM/DMAKI/Crypt-DH-GMP-0.00012.tar.gz";
    hash = "sha256-UeekeuWUz1X2bAdi9mkhVIbn2LNGC9rf55NQzPJtrzg=";
  };

  buildInputs = [
    gmp
    DevelChecklib
    TestRequires
  ];

  env.NIX_CFLAGS_COMPILE = "-I${gmp.dev}/include";

  env.NIX_CFLAGS_LINK = "-L${gmp.out}/lib -lgmp";

  meta = {
    description = "Crypt::DH Using GMP Directly";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
