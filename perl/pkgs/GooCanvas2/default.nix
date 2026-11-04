{
  buildPerlPackage,
  fetchurl,
  lib,
  gtk3,
  goocanvas,
  Gtk3,
}:
buildPerlPackage {
  pname = "GooCanvas2";
  version = "0.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PERLMAX/GooCanvas2-0.06.tar.gz";
    hash = "sha256-4kyHhz4ZBj3U1eLHCcqs+MCuiIEEQ5W7hl3CtP3WO1A=";
  };

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    goocanvas
    Gtk3
  ];

  meta = {
    description = "Perl binding for GooCanvas2 widget using Glib::Object::Introspection";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
