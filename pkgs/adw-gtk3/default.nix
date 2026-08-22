{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  dart-sass ? null,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adw-gtk3";
  version = "6.5";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7tCmtSauWUEoQUvOVnL4Zq+Om+9bHUCl1mDUejxjP78=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    dart-sass
  ];

  meta = {
    description = "Unofficial GTK 3 port of libadwaita";
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
