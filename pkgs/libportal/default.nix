{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libportal";
  version = "0.10.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = finalAttrs.version;
    sha256 = "sha256-vU3jnHxCvxZMSJOh5hzkCB8uuE0NnbnZM7+eQ6a5+oI=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    (lib.mesonEnable "backend-gtk3" false)
    (lib.mesonEnable "backend-gtk4" false)
    (lib.mesonEnable "backend-qt5" false)
    (lib.mesonEnable "backend-qt6" false)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "docs" true)
  ];

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
