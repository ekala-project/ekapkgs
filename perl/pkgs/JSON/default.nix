{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
  TestPod,
}:
buildPerlPackage {
  pname = "JSON";
  version = "4.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz";
    hash = "sha256-34tRQ9mn3pnEe1XxoXC9H2n3EZNcGGptwKtW3QV1jjU=";
  };
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace lib/JSON.pm \
      --replace-fail 'my $backend = exists $ENV{PERL_JSON_BACKEND} ? $ENV{PERL_JSON_BACKEND} : 1;' \
                     'my $backend = "JSON::PP";'
  '';
  buildInputs = [ TestPod ];
  meta = {
    description = "JSON (JavaScript Object Notation) encoder/decoder";
  };
}
