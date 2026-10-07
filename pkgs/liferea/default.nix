{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  python3Packages,
  glib,
  libxml2,
  libxslt,
  sqlite,
  libsoup_3,
  webkitgtk,
  json-glib,
  gstreamer,
  libnotify,
  gtk3,
  gsettings-desktop-schemas,
  libpeas2,
  libsecret,
  glib-networking,
}:

stdenv.mkDerivation rec {
  pname = "liferea";
  version = "1.16.14";

  src = fetchurl {
    url = "https://github.com/lwindolf/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-/zux42TNR453/XCep9/BJgObEXwT5Lq0dAVbucET1Og=";
  };

  nativeBuildInputs = [
    gtk3.wrapGAppsHook
    python3Packages.wrapPython
    intltool
    pkg-config
  ];

  configureFlags = [
    "--disable-introspection"
  ];

  buildInputs = [
    glib
    gtk3
    (webkitgtk.gtk3.override { enableGeoLocation = false; })
    libxml2
    libxslt
    sqlite
    libsoup_3
    libpeas2
    gsettings-desktop-schemas
    json-glib
    libsecret
    glib-networking
    libnotify
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
  ];


  postFixup = ''
    buildPythonPath ${python3Packages.pycairo}
    patchPythonScript $out/lib/liferea/plugins/trayicon.py

    buildPythonPath ${python3Packages.requests}
    patchPythonScript $out/lib/liferea/plugins/download-manager.py
  '';

  meta = {
    description = "GTK-based news feed aggregator";
    homepage = "http://lzone.de/liferea/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;

    longDescription = ''
      Liferea (Linux Feed Reader) is an RSS/RDF feed reader.
      It's intended to be a clone of the Windows-only FeedReader.
      It can be used to maintain a list of subscribed feeds,
      browse through their items, and show their contents.
    '';
  };
}
