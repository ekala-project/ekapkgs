{
  lib,
  stdenv,
  fetchurl,
  writeShellScriptBin,
  meson,
  ninja,
  pkg-config,
  gdk-pixbuf,
  librsvg,
  hicolor-icon-theme,
}:

let
  # Provide a stub gtk-update-icon-cache since gtk3 is not available
  gtk-update-icon-cache = writeShellScriptBin "gtk-update-icon-cache" ''
    exec true
  '';
in

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major version}/adwaita-icon-theme-${version}.tar.xz";
    hash = "sha256-hHBoiIZQ2WcxFb5tvyv9wxpGrrxSimqdtEIOYOZWuNQ=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk-update-icon-cache
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  postPatch = ''
    substituteInPlace index.theme \
      --replace-fail "Hidden=true" "" \
      --replace-fail "Inherits=AdwaitaLegacy,hicolor" "Inherits=hicolor"
  '';

  dontDropIconThemeCache = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/adwaita-icon-theme";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.cc-by-sa-30;
  };
}
