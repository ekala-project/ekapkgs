{
  buildPerlPackage,
  fetchurl,
  AnyEvent,
  commonsense,
}:
buildPerlPackage {
  pname = "AnyEvent-HTTP";
  version = "2.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/AnyEvent-HTTP-2.25.tar.gz";
    hash = "sha256-XPpTQWEkF29vTNMrAOqMp5otXfUSWGg5ic0E/obiUBM=";
  };
  propagatedBuildInputs = [
    AnyEvent
    commonsense
  ];
  meta = {
    description = "Simple but non-blocking HTTP/HTTPS client";
  };
}
