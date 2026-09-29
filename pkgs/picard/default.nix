{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  chromaprint,
  gettext,
  qt5,

  enablePlayback ? true,
  gstreamer,

  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python3Packages;
  pyqt5 = if enablePlayback then pythonPackages.pyqt5-multimedia else pythonPackages.pyqt5;
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "picard";
  version = "2.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-Q0W5Q1+PbN+yneh98jx0/UNHVfD6okX92hxNzCE+Ibc=";
  };

  nativeBuildInputs = [
    gettext
    qt5.wrapQtAppsHook
    pythonPackages.setuptools
  ];

  buildInputs = [
    qt5.qtbase
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform qt5.qtwayland) [
    qt5.qtwayland
  ]
  ++ lib.optionals pyqt5.multimediaEnabled [
    qt5.qtmultimedia.bin
    gstreamer.libav
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
  ];

  dependencies = with pythonPackages; [
    charset-normalizer
    chromaprint
    discid
    fasteners
    markdown
    mutagen
    pyjwt
    pyqt5
    python-dateutil
    pyyaml
  ];

  setupPyGlobalFlags = [
    "build"
    "--disable-autoupdate"
    "--localedir=${placeholder "out"}/share/locale"
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];
  doCheck = true;

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  ''
  + lib.optionalString pyqt5.multimediaEnabled ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    homepage = "https://picard.musicbrainz.org";
    changelog = "https://picard.musicbrainz.org/changelog";
    description = "Official MusicBrainz tagger";
    mainProgram = "picard";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
