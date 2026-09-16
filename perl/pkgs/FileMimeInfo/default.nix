{
  buildPerlPackage,
  fetchurl,
  FileBaseDir,
  FileDesktopEntry,
  EncodeLocale,
}:
buildPerlPackage {
  pname = "File-MimeInfo";
  version = "0.33";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MICHIELB/File-MimeInfo-0.33.tar.gz";
    hash = "sha256-9r6ms4kGITJeycJ5KvruiOlIoK4dEIcvpyxxELPhscQ=";
  };
  doCheck = false;
  buildInputs = [
    FileBaseDir
    FileDesktopEntry
    EncodeLocale
  ];
  meta = {
    description = "Determine file type from the file name";
  };
}
