{
  buildPerlPackage,
  fetchurl,
  TestException,
}:
buildPerlPackage {
  pname = "PerlIO-utf8_strict";
  version = "0.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.010.tar.gz";
    hash = "sha256-vNKEi3LfKQtemE+uixpsqW9tByADzyIjiajJ6OHFcM0=";
  };
  buildInputs = [ TestException ];
}
