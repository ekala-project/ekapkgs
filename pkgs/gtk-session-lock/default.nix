{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gtk3,
  wayland-scanner,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-session-lock";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Cu3PO42";
    repo = "gtk-session-lock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SHKAYmdev08oRB/V6UpfSFqYwplF59IaNSOoWcACPig=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    vala
    wayland-scanner
  ];

  buildInputs = [
    gtk3
    wayland
  ];

  strictDeps = true;

  meta = {
    description = "Library to use GTK 3 to build screen lockers using ext-session-lock-v1 protocol";
    homepage = "https://github.com/Cu3PO42/gtk-session-lock";
    # The author stated "GTK Session Lock is licensed under the GNU General
    # Public License version 3.0 or any later version approved by me (Cu3PO42)."
    # Since we don't know if the author will approve later versions, we mark gpl3Only
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
