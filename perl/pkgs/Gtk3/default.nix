{
  buildPerlPackage,
  fetchurl,
  lib,
  CairoGObject,
  GlibObjectIntrospection,
  gtk3,
}:
buildPerlPackage {
  pname = "Gtk3";
  version = "0.038";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Gtk3-0.038.tar.gz";
    hash = "sha256-cNxL8qp0mBx54V/SmNmY4FqS66SBHxrVyfH03jdzesw=";
  };

  propagatedBuildInputs = [
    gtk3
    CairoGObject
    GlibObjectIntrospection
  ];

  meta = {
    description = "Perl interface to the 3.x series of the gtk+ toolkit";
    license = lib.licenses.lgpl21Plus;
  };
}
