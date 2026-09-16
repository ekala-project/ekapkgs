{
  buildPerlPackage,
  fetchurl,
  lib,
  coreutils,
}:
buildPerlPackage {
  pname = "PathTools";
  version = "3.75";
  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XS/XSAWYERX/PathTools-3.75.tar.gz";
    hash = "sha256-pVhQOqax+McnwAczOQgad4iGBqpwGtoa1i3Z2MP5RaI=";
  };
  preConfigure = ''
    substituteInPlace Cwd.pm --replace '/usr/bin/pwd' '${coreutils}/bin/pwd'
  '';
  # cwd() and fastgetcwd() does not work with taint due to PATH in nixpkgs
  preCheck = "rm t/taint.t";
  meta = {
    description = "Get pathname of current working directory";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
