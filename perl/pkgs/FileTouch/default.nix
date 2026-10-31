{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "File-Touch";
  version = "0.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/File-Touch-0.12.tar.gz";
    hash = "sha256-KgTcQk30jpjFRVbGBFyrAmpJ43N6qUohz0l3YbDy5Zw=";
  };
  meta = {
    description = "Update file access and modification times, optionally creating files if needed";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
