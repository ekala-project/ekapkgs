{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gstreamer,
  gtk4,
  lib,
  libadwaita,
  python3Packages,
  v4l-utils,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "link-studio";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jweaver60";
    repo = "link-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Naxx3Z5FPNDz8207609a46Ijx9rbWGZQRC3lhQjheeI=";
  };

  # mediapipe and opencv-contrib-python are declared as hard deps upstream but
  # are only imported lazily for optional video effects.  Strip them so the
  # runtime-deps check passes without pulling in heavy ML libraries.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"mediapipe>=1.0.1",' "" \
      --replace-fail '"opencv-contrib-python>=4.10",' ""
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    numpy
    pygobject3
    qrcode
  ];

  buildInputs = [
    glib
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.libav
    gtk4
    libadwaita
    v4l-utils
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;

  meta = {
    description = "Native Linux controller for Insta360 Link webcams";
    homepage = "https://github.com/jweaver60/link-studio";
    changelog = "https://github.com/jweaver60/link-studio/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "link-studio";
  };
})
