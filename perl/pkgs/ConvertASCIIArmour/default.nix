{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Convert-ASCII-Armour";
  version = "1.4";
  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VI/VIPUL/Convert-ASCII-Armour-1.4.tar.gz";
    hash = "sha256-l+istusqKpGvfWzw0t/2+kKq+Tn8fW0cYFek8N9SyQQ=";
  };
  meta = {
    description = "Convert binary octets into ASCII armoured messages";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
