{
  buildPerlPackage,
  fetchurl,
  CloneChoose,
  Clone,
  ClonePP,
}:
buildPerlPackage {
  pname = "Hash-Merge";
  version = "0.302";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HE/HERMES/Hash-Merge-0.302.tar.gz";
    hash = "sha256-rgUi92U5YIth3eFGcOeWd+DzkQNoMvcKIfMa3eJThkQ=";
  };
  propagatedBuildInputs = [ CloneChoose ];
  buildInputs = [
    Clone
    ClonePP
  ];
  meta = {
    description = "Merges arbitrarily deep hashes into a single hash";
  };
}
