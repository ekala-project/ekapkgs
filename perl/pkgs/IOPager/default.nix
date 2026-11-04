{
  buildPerlPackage,
  fetchurl,
  lib,
  more,
  FileWhich,
  TermReadKey,
}:
buildPerlPackage {
  pname = "IO-Pager";
  version = "2.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-2.10.tgz";
    hash = "sha256-vLTYwtKAyANLglkcwLnrZ6AE+QzpqgWXn8YHEwessZU=";
  };

  propagatedBuildInputs = [
    more
    FileWhich
    TermReadKey
  ];

  meta = {
    description = "Select a pager (possibly perl-based) & pipe it text if a TTY";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "tp";
  };
}
