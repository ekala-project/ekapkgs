{
  lib,
  fetchurl,
  intltool,
  libtorrent-rasterbar,
  python3Packages,
  python3,
  boost,
  gtk3,
  libappindicator,
  glib,
  gobject-introspection,
  librsvg,
  withGUI ? true,
}:

let
  pypkgs = python3Packages;

  boostPython =
    (boost.override {
      enablePython = true;
      python = python3;
    }).overrideAttrs
      (old: {
        # Fix preConfigure not taking effect in structured attrs by appending
        # the python config to project-config.jam after bootstrap generates it
        postConfigure = (old.postConfigure or "") + ''
          cat >> project-config.jam <<EOF
          using python : : ${python3}/bin/python3 : ${python3}/include/${python3.libPrefix} : ${python3}/lib ;
          EOF
        '';
      });

  libtorrent-rasterbar-python = libtorrent-rasterbar.overrideAttrs (old: {
    cmakeEntries = old.cmakeEntries // {
      python-bindings = true;
    };
    buildInputs = [
      boostPython
    ]
    ++ (builtins.filter (x: x != boost) old.buildInputs);
    nativeBuildInputs = old.nativeBuildInputs ++ [
      python3
    ];
  });
in
pypkgs.buildPythonPackage (finalAttrs: {
  pname = if withGUI then "deluge-gtk" else "deluged";
  version = "2.2.0";
  format = "setuptools";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/${lib.versions.majorMinor finalAttrs.version}/deluge-${finalAttrs.version}.tar.xz";
    hash = "sha256-ubonK1ukKq8caU5sKWKKuBbMGnAKN7rAiqy1JXFgas0=";
  };

  patches = [
    ./replace-pyopenssl-certificate-generation.patch
  ];

  propagatedBuildInputs =
    with pypkgs;
    [
      twisted
      mako
      chardet
      cryptography
      pyxdg
      pyopenssl
      service-identity
      libtorrent-rasterbar-python
      setuptools
      setproctitle
      pillow
      rencode
      six
      zope-interface
      dbus-python
    ]
    ++ lib.optionals withGUI [
      pycairo
      librsvg
      gtk3
      gobject-introspection
      pygobject3
      libappindicator
    ];

  nativeBuildInputs = [
    intltool
    glib
  ]
  ++ lib.optionals withGUI [
    gobject-introspection
    gtk3.wrapGAppsHook
  ];

  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system packaging/systemd/*.service
  ''
  + (
    if withGUI then
      ''
        mkdir -p $out/share
        cp -R deluge/ui/data/{icons,pixmaps} $out/share/
        install -Dm444 -t $out/share/applications deluge/ui/data/share/applications/deluge.desktop
      ''
    else
      ''
        rm -r $out/bin/deluge-gtk
        rm -r $out/${pypkgs.python.sitePackages}/deluge/ui/gtk3
        rm -r $out/share/{icons,man/man1/deluge-gtk*,pixmaps}
      ''
  );

  postFixup = ''
    for f in $out/lib/systemd/system/*; do
      substituteInPlace $f --replace /usr/bin $out/bin
    done
  '';

  meta = {
    description = "Torrent client";
    homepage = "https://deluge-torrent.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
