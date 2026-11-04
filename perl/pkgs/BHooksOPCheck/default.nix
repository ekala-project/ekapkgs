{
  buildPerlPackage,
  fetchurl,
  lib,
  ExtUtilsDepends,
}:
buildPerlPackage {
  pname = "B-Hooks-OP-Check";
  version = "0.22";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz";
    hash = "sha256-x7XRvvWe+Qh/9n6zFo0mJL6UrlRkRp4lmtEb+4rYzc0=";
  };
  buildInputs = [ ExtUtilsDepends ];
  meta = {
    description = "Wrap OP check callbacks";
    homepage = "https://github.com/karenetheridge/B-Hooks-OP-Check";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
