{
  lib,
  stdenv,
  fetchurl,
  libotr,
  pidgin,
  intltool,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-otr";
  version = "4.0.2";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/pidgin-otr-${version}.tar.gz";
    hash = "sha256-HVWB8mRosMOEM2r/+P2wSs9GaaOw8tSlBs0q3IsBXfQ=";
  };

  postInstall = "ln -s $out/lib/pidgin $out/share/pidgin-otr";

  nativeBuildInputs = [ intltool ];

  buildInputs = [
    libotr
    pidgin
  ];

  meta = {
    homepage = "https://otr.cypherpunks.ca/";
    description = "Plugin for Pidgin 2.x which implements OTR Messaging";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
