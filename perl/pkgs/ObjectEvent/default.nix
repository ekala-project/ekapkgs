{
  buildPerlPackage,
  fetchurl,
  lib,
  AnyEvent,
  commonsense,
}:
buildPerlPackage rec {
  pname = "Object-Event";
  version = "1.23";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EL/ELMEX/Object-Event-${version}.tar.gz";
    hash = "sha256-q2u4BQj0/dry1RsgyodqqwOFgqhrUijmQ1QRNIr1PII=";
  };

  propagatedBuildInputs = [
    AnyEvent
    commonsense
  ];

  meta = {
    description = "Class that provides an event callback interface";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
