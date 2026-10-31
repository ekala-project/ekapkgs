{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "lib-relative";
  version = "1.002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DB/DBOOK/lib-relative-1.002.tar.gz";
    hash = "sha256-5EcCFRZ8QGkXYD54vk2TESz2kTzTQq64ALQS4BHIp4s=";
  };
  meta = {
    description = "Add paths relative to the current file to @INC";
    homepage = "https://github.com/Grinnz/lib-relative";
    license = lib.licenses.artistic2;
  };
}
