{
  buildPerlPackage,
  fetchurl,
  TestPod,
  TieIxHash,
  FileShareDirInstall,
  XXX,
}:
buildPerlPackage {
  pname = "Pegex";
  version = "0.75";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IN/INGY/Pegex-0.75.tar.gz";
    hash = "sha256-TcjTNd6AslJHzbP5RvDRDZugs8NLDtfQAxb9Bo/QXtw=";
  };
  buildInputs = [
    TestPod
    TieIxHash
  ];
  propagatedBuildInputs = [
    FileShareDirInstall
    XXX
  ];
  meta = {
    description = "Acmeist PEG Parser Framework";
  };
}
