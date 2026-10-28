{
  lib,
  fetchFromGitHub,
  gtk3,
  adwaita-icon-theme,
  gobject-introspection,
  intltool,
  python3Packages,
  xdg-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gpodder";
  version = "3.11.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "gpodder";
    tag = finalAttrs.version;
    hash = "sha256-Hhk9JeHMg+FrekiNXP6Q8loCtst+FHT4EJTnh64VOhc=";
  };

  patches = [
    ./disable-autoupdate.patch
  ];

  postPatch = ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder
  '';

  build-system = with python3Packages; [
    setuptools
    build
    installer
    wheel
  ];

  nativeBuildInputs = [
    intltool
    gtk3.wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
  ];

  nativeCheckInputs = with python3Packages; [
    minimock
    pytest
    pytest-httpserver
    pytest-cov-stub
  ];

  doCheck = true;

  propagatedBuildInputs = with python3Packages; [
    feedparser
    dbus-python
    mygpoclient
    requests
    pygobject3
    eyed3
    podcastparser
    html5lib
    mutagen
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "share/applications/gpodder-url-handler.desktop"
    "share/applications/gpodder.desktop"
    "share/dbus-1/services/org.gpodder.service"
  ];

  installCheckPhase = ''
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest --ignore=tests --ignore=src/gpodder/utilwin32ctypes.py --doctest-modules src/gpodder/util.py src/gpodder/jsonconfig.py
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest tests --ignore=src/gpodder/utilwin32ctypes.py --ignore=src/mygpoclient --cov=gpodder
  '';

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}" ];

  meta = {
    description = "Podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
