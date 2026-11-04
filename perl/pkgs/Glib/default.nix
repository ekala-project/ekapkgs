{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
  glib,
  pkg-config,
  ExtUtilsDepends,
  ExtUtilsPkgConfig,
}:
buildPerlPackage {
  pname = "Glib";
  version = "1.3294";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Glib-1.3294.tar.gz";
    hash = "sha256-1xX1qGvMGHB13oXnrlvAewcU1u3BlqktpDmG76ROXLs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ glib ];

  propagatedBuildInputs = [
    ExtUtilsDepends
    ExtUtilsPkgConfig
  ];

  meta = {
    description = "Perl wrappers for the GLib utility and Object libraries";
    homepage = "https://gtk2-perl.sourceforge.net";
    license = lib.licenses.lgpl21Only;
    # Can't load module IO, dynamic loading not available in this perl.
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
