{
  buildPerlModule,
  fetchurl,
  lib,
  ParamsClassify,
}:
buildPerlModule {
  pname = "Class-Mix";
  version = "0.006";

  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Class-Mix-0.006.tar.gz";
    hash = "sha256-h0f2Q4k5FPjESXnxcW0MHsikE5R5ZVVEeUToYPH/fAs=";
  };

  propagatedBuildInputs = [ ParamsClassify ];

  meta = {
    description = "Dynamic class mixing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
