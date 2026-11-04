{
  buildPerlPackage,
  fetchurl,
  lib,
  ExtUtilsDepends,
  TestRequires,
  BHooksEndOfScope,
  BHooksOPCheck,
  SubName,
}:
buildPerlPackage {
  pname = "Devel-Declare";
  version = "0.006022";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-Declare-0.006022.tar.gz";
    hash = "sha256-cvKco1ZGpZO+mDEf/dtyAzrh6KnYJUxiqiSL1iYOWW4=";
  };

  buildInputs = [
    ExtUtilsDepends
    TestRequires
  ];

  propagatedBuildInputs = [
    BHooksEndOfScope
    BHooksOPCheck
    SubName
  ];

  meta = {
    description = "(DEPRECATED) Adding keywords to perl, in perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
