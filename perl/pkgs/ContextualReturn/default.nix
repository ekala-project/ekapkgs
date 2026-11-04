{
  buildPerlPackage,
  fetchurl,
  Want,
}:
buildPerlPackage {
  pname = "Contextual-Return";
  version = "0.004014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCONWAY/Contextual-Return-0.004014.tar.gz";
    hash = "sha256-Cf4UFeFuSaaeE8DvbmpKP9i4VvOJ0/PmJNerO3Fxn3g=";
  };

  propagatedBuildInputs = [ Want ];

  meta = {
    description = "Create context-sensitive return values";
  };
}
