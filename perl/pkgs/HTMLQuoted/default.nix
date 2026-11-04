{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLParser,
}:
buildPerlPackage {
  pname = "HTML-Quoted";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TS/TSIBLEY/HTML-Quoted-0.04.tar.gz";
    hash = "sha256-i0HzE/3BgS8C9vbDfVjyEshP3PeCf3/UsDCQfzncZQw=";
  };
  propagatedBuildInputs = [ HTMLParser ];
  meta = {
    description = "Extract structure of quoted HTML mail message";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
