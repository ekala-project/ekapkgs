{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  inkscape,
  meson,
  ninja,
  python3,
  sassc,
  makeFontsConf,
  cinnamon-menus,
  gnome-shell,
}:

stdenv.mkDerivation {
  pname = "arc-theme";
  version = "20221218";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = "arc-theme";
    rev = "94ac8c7d67d68de0cc688bbd4c3105b9815b446e";
    hash = "sha256-vvZvJmsmeYcJT3xVQLg4tmYXEgHprWJls1fbxA3Jxnw=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-resources
    inkscape
    meson
    meson.configurePhaseHook
    ninja
    python3
    sassc
  ];

  postPatch = ''
    patchShebangs meson/install-file.py
  '';

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$TMPDIR"
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  mesonFlags = [
    (lib.mesonOption "themes" (
      lib.concatStringsSep "," [
        "cinnamon"
        "gnome-shell"
        # "gtk2" (no longer supported)
        "gtk3"
        "gtk4"
        "metacity"
        "plank"
        "unity"
        "xfwm"
      ]
    ))

    (lib.mesonOption "cinnamon_version" cinnamon-menus.version)
    (lib.mesonOption "gnome_shell_version" gnome-shell.version)

    # You will need to patch gdm to make use of this.
    (lib.mesonBool "gnome_shell_gresource" true)
  ];

  meta = {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
