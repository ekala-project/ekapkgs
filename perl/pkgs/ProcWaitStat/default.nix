{
  buildPerlPackage,
  fetchurl,
  lib,
  IPCSignal,
}:
buildPerlPackage {
  pname = "Proc-WaitStat";
  version = "1.00";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROSCH/Proc-WaitStat-1.00.tar.gz";
    hash = "sha256-0HVj9eeHkJ0W5zkCQeh39Jq3ObHenQ4uoaQb0L9EdLw=";
  };
  propagatedBuildInputs = [ IPCSignal ];
  meta = {
    description = "Interpret and act on wait() status values";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
