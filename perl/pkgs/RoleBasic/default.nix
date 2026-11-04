{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Role-Basic";
  version = "0.13";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/Role-Basic-0.13.tar.gz";
    hash = "sha256-OKCVnvnxk/925ywyWp6SEbxIaGib0OKwBXePU/i282o=";
  };
  meta = {
    description = "Just roles. Nothing else";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
