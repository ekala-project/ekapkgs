{
  buildPerlModule,
  fetchurl,
  Moo,
  PathTiny,
}:
buildPerlModule {
  pname = "Dir-Manifest";
  version = "0.6.1";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Dir-Manifest-0.6.1.tar.gz";
    hash = "sha256-hP9yJoc9XoZW7Hc0TAg4wVOp8BW0a2Dh/oeYuykn5QU=";
  };
  propagatedBuildInputs = [
    Moo
    PathTiny
  ];
  meta = {
    description = "Treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs";
  };
}
