{
  buildPerlPackage,
  fetchurl,
  lib,
  FileHandleUnget,
  FileSlurper,
  TestCompile,
  TestPod,
  TestPodCoverage,
  TextDiff,
  UNIVERSALrequire,
  URI,
}:
buildPerlPackage {
  pname = "Mail-Mbox-MessageParser";
  version = "1.5111";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCOPPIT/Mail-Mbox-MessageParser-1.5111.tar.gz";
    hash = "sha256-VyPAqpzBC6ue0eO/2dXJX3FZ5xwaR1QU6xrx3uOkYjc=";
  };
  buildInputs = [
    FileSlurper
    TestCompile
    TestPod
    TestPodCoverage
    TextDiff
    UNIVERSALrequire
    URI
  ];
  propagatedBuildInputs = [ FileHandleUnget ];
  meta = {
    description = "Fast and simple mbox folder reader";
    homepage = "https://github.com/coppit/mail-mbox-messageparser";
    license = lib.licenses.gpl2Only;
  };
}
