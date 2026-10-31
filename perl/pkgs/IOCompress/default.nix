{
  buildPerlPackage,
  fetchurl,
  lib,
  CompressRawBzip2,
  CompressRawZlib,
}:
buildPerlPackage {
  pname = "IO-Compress";
  version = "2.221";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/IO-Compress-2.221.tar.gz";
    hash = "sha256-r0LJyRBK3313LSVcDZpASjRi6kXnvELQbaCgtR3j0K4=";
  };
  propagatedBuildInputs = [
    CompressRawBzip2
    CompressRawZlib
  ];
  doCheck = false;
  meta = {
    description = "IO Interface to compressed data files/buffers";
    homepage = "https://github.com/pmqs/IO-Compress";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "streamzip";
  };
}
