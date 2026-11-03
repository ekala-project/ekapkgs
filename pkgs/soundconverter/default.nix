{
  lib,
  fetchFromGitHub,
  glib,
  python3Packages,
  gtk3,
  gsettings-desktop-schemas,
  intltool,
  gobject-introspection,
  gstreamer,
  fdk-aac-encoder,
}:

python3Packages.buildPythonApplication rec {
  pname = "soundconverter";
  version = "4.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kassoulet";
    repo = "soundconverter";
    tag = version;
    hash = "sha256-qa8VBPpB27hw+mYXGi6I35dxjJAOucH/SevxqKeu6o0=";
  };

  buildInputs = [
    gtk3
    fdk-aac-encoder
    gstreamer.libav
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-ugly
    gstreamer.plugins-bad
  ];

  nativeBuildInputs = [
    intltool
    gtk3.wrapGAppsHook
    gobject-introspection
  ];

  dependencies = with python3Packages; [
    gst-python
    distutils-extra
    setuptools
    pygobject3
  ];

  postPatch = ''
    substituteInPlace  bin/soundconverter --replace \
      "DATA_PATH = os.path.join(SOURCE_PATH, 'data')" \
      "DATA_PATH = '$out/share/soundconverter'"
  '';

  doCheck = false;

  strictDeps = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://soundconverter.org/";
    description = "Leading audio file converter for the GNOME Desktop";
    mainProgram = "soundconverter";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
