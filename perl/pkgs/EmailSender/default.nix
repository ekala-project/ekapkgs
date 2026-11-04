{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  EmailAbstract,
  EmailAddressXS,
  EmailSimple,
  ModuleRuntime,
  Moo,
  MooXTypesMooseLike,
  SubExporter,
  Throwable,
  TryTiny,
}:
buildPerlPackage {
  pname = "Email-Sender";
  version = "2.600";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Sender-2.600.tar.gz";
    hash = "sha256-7MZ10DDXnZpPsGRWfqiFxmsXw4Yjea0w+CBaKBzY7ik=";
  };

  buildInputs = [ CaptureTiny ];

  propagatedBuildInputs = [
    EmailAbstract
    EmailAddressXS
    EmailSimple
    ModuleRuntime
    Moo
    MooXTypesMooseLike
    SubExporter
    Throwable
    TryTiny
  ];

  postPatch = ''
    patchShebangs --build util
  '';

  meta = {
    description = "Library for sending email";
    homepage = "https://github.com/rjbs/Email-Sender";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
