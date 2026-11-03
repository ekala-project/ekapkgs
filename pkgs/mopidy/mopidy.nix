{
  lib,
  stdenv,
  fetchFromGitHub,
  pythonPackages,
  wrapGAppsNoGuiHook,
  gstreamer,
  glib-networking,
  gobject-introspection,
  pipewire,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2OFav2HaQq/RphmZxLyL1n3suwzt1Y/d4h33EdbStjk=";
  };

  nativeBuildInputs = [ wrapGAppsNoGuiHook ];

  buildInputs = [
    glib-networking
    gstreamer.plugins-bad
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-ugly
    # TODO(ekaos): gst-plugins-rs not available
    gstreamer.libav
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pipewire ];

  propagatedNativeBuildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [ gobject-introspection ];

  build-system = [ pythonPackages.setuptools ];

  dependencies =
    with pythonPackages;
    [
      gst-python
      pygobject3
      pykka
      requests
      # Provides pkg_resources required by Mopidy 3 and affected extensions.
      # Remove when updating to Mopidy 4.
      setuptools_80
      tornado
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ dbus-python ];

  # There are no tests
  doCheck = false;

  # TODO(ekaos): replace with integrationTests
  # passthru.tests = {
  #   inherit (nixosTests) mopidy;
  # };

  meta = {
    homepage = "https://www.mopidy.com/";
    description = "Extensible music server that plays music from local disk, Spotify, SoundCloud, and more";
    mainProgram = "mopidy";
    license = lib.licenses.asl20;
    hydraPlatforms = [ ];
  };
})
