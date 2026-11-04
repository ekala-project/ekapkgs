{
  buildPerlPackage,
  fetchurl,
  lib,
  Gtk3,
}:
buildPerlPackage {
  pname = "Gtk3-SimpleList";
  version = "0.21";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TV/TVIGNAUD/Gtk3-SimpleList-0.21.tar.gz";
    hash = "sha256-HURlEAvzvAR0opRppAb9AzVituNzYYgSEAA3KrKtqIQ=";
  };

  propagatedBuildInputs = [ Gtk3 ];

  meta = {
    description = "Simple interface to Gtk3's complex MVC list widget";
    license = lib.licenses.lgpl21Plus;
  };
}
