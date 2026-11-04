{
  buildPerlPackage,
  fetchurl,
  lib,
  BHooksEndOfScope,
  PackageStash,
}:
buildPerlPackage {
  pname = "namespace-clean";
  version = "0.27";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz";
    hash = "sha256-ihCoPD4YPcePnnt6pNCbR8EftOfTozuaEpEv0i4xr50=";
  };

  propagatedBuildInputs = [
    BHooksEndOfScope
    PackageStash
  ];

  meta = {
    description = "Keep imports and functions out of your namespace";
    homepage = "https://search.cpan.org/dist/namespace-clean";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
