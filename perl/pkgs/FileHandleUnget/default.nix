{
  buildPerlPackage,
  fetchurl,
  lib,
  FileSlurper,
  TestCompile,
  UNIVERSALrequire,
  URI,
}:
buildPerlPackage {
  pname = "FileHandle-Unget";
  version = "0.1634";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DC/DCOPPIT/FileHandle-Unget-0.1634.tar.gz";
    hash = "sha256-OA80rTzl6exmHUxGi7M5IjHBYjF9QXLfN4FGtCqrF4U=";
  };

  buildInputs = [
    FileSlurper
    TestCompile
    UNIVERSALrequire
    URI
  ];

  meta = {
    description = "FileHandle which supports multi-byte unget";
    homepage = "https://github.com/coppit/filehandle-unget";
    license = lib.licenses.gpl2Only;
  };
}
