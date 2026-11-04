{
  buildPerlPackage,
  fetchurl,
  ParseRecDescent,
  TieIxHash,
}:
buildPerlPackage {
  pname = "ExtUtils-XSBuilder";
  version = "0.28";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz";
    hash = "sha256-jM7ThuPVRMXsLes67QVbcuvPwuqabIB9qHxCRScv6Ao=";
  };

  propagatedBuildInputs = [
    ParseRecDescent
    TieIxHash
  ];

  meta = {
    description = "Automatic Perl XS glue code generation";
  };
}
