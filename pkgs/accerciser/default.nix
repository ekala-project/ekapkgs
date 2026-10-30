{
  lib,
  fetchurl,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  gtk3,
  gobject-introspection,
  itstool,
  python3,
  at-spi2-core,
  gettext,
  libwnck,
  librsvg,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "accerciser";
  version = "3.48.0";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${lib.versions.majorMinor finalAttrs.version}/accerciser-${finalAttrs.version}.tar.xz";
    hash = "sha256-kCiOiQCidKOu4gUw6zkWRZlK6YZyIJFroPXEZ3v+n00=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    gtk3
    libwnck
    librsvg
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      dbus-python
      ipython
      pycairo
      pygobject3
      pyxdg
      setuptools
    ]
    ++ lib.optionals (python3.pkgs ? pyatspi) [
      python3.pkgs.pyatspi
    ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/accerciser";
    changelog = "https://gitlab.gnome.org/GNOME/accerciser/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Interactive Python accessibility explorer";
    mainProgram = "accerciser";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
