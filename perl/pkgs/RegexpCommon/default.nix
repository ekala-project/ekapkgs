{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Regexp-Common";
  version = "2017060201";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz";
    hash = "sha256-7geFOu4G8xDgQLa/GgGZoY2BiW0yGbmzXJYw0OtpCJs=";
  };
}
