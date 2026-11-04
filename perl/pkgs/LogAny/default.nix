{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Log-Any";
  version = "1.717";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PR/PREACTION/Log-Any-1.717.tar.gz";
    hash = "sha256-VmSdoPOQAjDJ49KSUssKdIBvst3r0igFrNc2iVmmW8o=";
  };

  preCheck = "rm t/syslog.t";

  meta = {
    description = "Bringing loggers and listeners together";
    homepage = "https://github.com/preaction/Log-Any";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
