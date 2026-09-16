{
  buildPerlPackage,
  fetchurl,
  HTTPDate,
  TestDeep,
  TestRequires,
  URI,
}:
buildPerlPackage {
  pname = "HTTP-CookieJar";
  version = "0.014";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/HTTP-CookieJar-0.014.tar.gz";
    hash = "sha256-cJTqXJH1NtJjuF6Dq06alj4RxECM4I7K5VP6nAzEfnM=";
  };
  propagatedBuildInputs = [ HTTPDate ];
  buildInputs = [
    TestDeep
    TestRequires
    URI
  ];
  doCheck = false;
  meta = {
    description = "Minimalist HTTP user agent cookie jar";
  };
}
