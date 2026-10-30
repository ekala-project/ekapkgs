{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  Glib,
  cairo,
  gobject-introspection,
  pkg-config,
}:
buildPerlPackage {
  pname = "Glib-Object-Introspection";
  version = "0.051";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Glib-Object-Introspection-0.051.tar.gz";
    hash = "sha256-ZWlhHcyArBSCx8IiZLGujJw1HUmDUR65psX0ehAVAIk=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/perl-glib-object-introspection/-/commit/e5adffecdc9b321d1f8d91777b190b8ae08f8dd0.patch";
      hash = "sha256-/QAhKENSeP+QRoWx/v8EMFPOouZ36Qd78lhZpvInz7Q=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
  ];

  propagatedBuildInputs = [
    gobject-introspection
    Glib
  ];

  meta = {
    description = "Dynamically create Perl language bindings";
    homepage = "https://gtk2-perl.sourceforge.net";
    license = lib.licenses.lgpl21Only;
  };
}
