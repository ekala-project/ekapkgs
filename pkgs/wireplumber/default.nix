{
  lib,
  stdenv,
  fetchFromGitLab,
  # base build deps
  meson,
  pkg-config,
  ninja,
  # docs build deps
  python3,
  doxygen,
  graphviz,
  # GI build deps
  gobject-introspection,
  # runtime deps
  glib,
  systemd,
  lua,
  pipewire,
  # options
  enableDocs ? true,
  enableGI ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wireplumber";
  version = "0.5.15";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional enableDocs "doc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "wireplumber";
    tag = finalAttrs.version;
    hash = "sha256-28JrX8V23VpTe6GPI6g/JlN7412yJLMcwEre2Jv77qg=";
  };

  strictDeps = true;
  separateDebugInfo = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
  ]
  ++ lib.optionals enableDocs [
    graphviz
  ]
  ++ lib.optionals enableGI [
    gobject-introspection
  ]
  ++ lib.optionals (enableDocs || enableGI) [
    doxygen
    (python3.pythonOnBuildForHost.withPackages (
      ps:
      with ps;
      lib.optionals enableDocs [
        sphinx
        sphinx-rtd-theme
        breathe
      ]
      ++ lib.optionals enableGI [ lxml ]
    ))
  ];

  buildInputs = [
    glib
    systemd
    lua
    pipewire
  ];

  mesonEntries = {
    system-lua = true;
    systemd-system-service = true;
    systemd-system-unit-dir = "${placeholder "out"}/lib/systemd/system";
    sysconfdir = "/etc";
  };

  mesonFeatures = {
    elogind = false;
    doc = enableDocs;
    introspection = enableGI;
  };

  meta = {
    description = "Modular session / policy manager for PipeWire";
    homepage = "https://pipewire.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
