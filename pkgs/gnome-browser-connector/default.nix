{
  lib,
  fetchurl,
  meson,
  ninja,
  python3,
  gnome-shell ? null, # TODO: not in ekapkgs, needs porting or corepkgs
  wrapGAppsNoGuiHook,
  gobject-introspection,
}:

let
  inherit (python3.pkgs) buildPythonApplication;
in
buildPythonApplication (finalAttrs: {
  pname = "gnome-browser-connector";
  version = "42.1";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-browser-connector/${lib.versions.major finalAttrs.version}/gnome-browser-connector-${finalAttrs.version}.tar.xz";
    sha256 = "vZcCzhwWNgbKMrjBPR87pugrJHz4eqxgYQtBHfFVYhI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsNoGuiHook
    gobject-introspection # for setup-hook
  ];

  buildInputs = lib.optional (gnome-shell != null) gnome-shell;

  pythonPath = lib.optional (python3.pkgs ? pygobject3) python3.pkgs.pygobject3;

  postPatch = ''
    patchShebangs contrib/merge_json.py
  '';

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Native host connector for the GNOME Shell browser extension";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-browser-connector";
    longDescription = ''
      To use the integration, install the browser extension from
      https://gitlab.gnome.org/GNOME/gnome-browser-extension.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
