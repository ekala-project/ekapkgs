{
  buildPerlPackage,
  fetchurl,
  lib,
  DateManip,
  LogDispatch,
  PathTiny,
  TestWarn,
}:
buildPerlPackage {
  pname = "Log-Dispatch-FileRotate";
  version = "1.38";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Log-Dispatch-FileRotate-1.38.tar.gz";
    hash = "sha256-tV1s7ePwoGQmSI+/pVT0VhMgsBTBAjiTztKVCOW85Ow=";
  };
  propagatedBuildInputs = [
    DateManip
    LogDispatch
  ];
  buildInputs = [
    PathTiny
    TestWarn
  ];
  meta = {
    description = "Log to Files that Archive/Rotate Themselves";
    homepage = "https://github.com/mschout/perl-log-dispatch-filerotate";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
