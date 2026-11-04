{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassDataInheritable,
  DateTimeFormatNatural,
  TestMockTimeHiRes,
}:
buildPerlPackage {
  pname = "Date-Extract";
  version = "0.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Date-Extract-0.07.tar.gz";
    hash = "sha256-+geIBK3k7uwd4UcuDguwR65i5MjU1QIHAbnlBXfFuPQ=";
  };

  buildInputs = [ TestMockTimeHiRes ];

  propagatedBuildInputs = [
    ClassDataInheritable
    DateTimeFormatNatural
  ];

  meta = {
    description = "Extract probable dates from strings";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
