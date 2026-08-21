{
  dbus,
  fetchFromGitLab,
  gobject-introspection,
  lib,
  libadwaita,
  meson,
  ninja,
  python3,
  stdenv,
  wrapGAppsNoGuiHook,
  xvfb-run ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blueprint-compiler";
  version = "0.20.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "blueprint-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dA+FQTRmTz6rl5ToZJ8CXY1Zd7Em7VwvF3U3Qoyvu80=";
  };

  postPatch = ''
    patchShebangs docs/collect-sections.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    python3
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    libadwaita
    python3
  ];

  propagatedBuildInputs = [
    # For setup hook, so that the compiler can find typelib files
    gobject-introspection
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  # requires xvfb-run
  doCheck = !stdenv.hostPlatform.isDarwin && false; # tests time out

  checkPhase = ''
    runHook preCheck

    xvfb-run dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  strictDeps = true;

  meta = {
    description = "Markup language for GTK user interface files";
    mainProgram = "blueprint-compiler";
    homepage = "https://gitlab.gnome.org/GNOME/blueprint-compiler";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
