{
  version,
  src-hash,
  variant ? null,
  mkVariantPassthru,
  ...
}@variantArgs:

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
  gtk3,
  gtk4 ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libportal" + lib.optionalString (variant != null) "-${variant}";
  inherit version;

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "libportal";
    rev = finalAttrs.version;
    hash = src-hash;
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
  ]
  ++ lib.optionals (variant == "gtk3") [
    gtk3
  ]
  ++ lib.optionals (variant == "gtk4") [
    gtk4
  ];

  mesonFlags = [
    (lib.mesonEnable "backend-gtk3" (variant == "gtk3"))
    (lib.mesonEnable "backend-gtk4" (variant == "gtk4"))
    (lib.mesonEnable "backend-qt5" false)
    (lib.mesonEnable "backend-qt6" false)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "docs" true)
  ];

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
