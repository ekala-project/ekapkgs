{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Test-Refcount";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Refcount-0.10.tar.gz";
    hash = "sha256-BFfCCklWRz0VfE+q/4gUFUvJP24rVDwoEqGf+OM3DrI=";
  };
  meta = {
    description = "Assert reference counts on objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
