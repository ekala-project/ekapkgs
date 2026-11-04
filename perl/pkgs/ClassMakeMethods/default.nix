{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-MakeMethods";
  version = "1.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EV/EVO/Class-MakeMethods-1.01.tar.gz";
    hash = "sha256-rKx0LnnQ7Ip75Nj7gTqF6kTUfRnAFwzdswZEYCtYLGY=";
  };
  preConfigure = ''
    # fix error 'Unescaped left brace in regex is illegal here in regex'
    substituteInPlace tests/xemulator/class_methodmaker/Test.pm --replace 's/(TEST\s{)/$1/g' 's/(TEST\s\{)/$1/g'
  '';
  meta = {
    description = "Generate common types of methods";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
