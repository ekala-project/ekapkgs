{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Module-Runtime";
  version = "0.016";

  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz";
    hash = "sha256-aDAuxkaDNUfUEL4o4JZ223UAb0qlihHzvbRP/pnw8CQ=";
  };

  meta = {
    description = "Runtime module handling";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
