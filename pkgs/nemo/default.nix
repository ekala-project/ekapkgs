{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  lib,
  stdenv,
  wrapGAppsHook3,
  libxmlb,
  gtk3,
  gvfs,
  cinnamon-desktop,
  xapp,
  xapp-symbolic-icons,
  xdg-user-dirs,
  libexif,
  json-glib,
  exempi,
  intltool,
  shared-mime-info,
  cinnamon-translations,
  libgsf,
  python3,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      pycairo
      pygobject3
      python-xapp
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nemo";
  version = "6.6.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo";
    rev = finalAttrs.version;
    hash = "sha256-HYrpq22rWScdweDQQlrQbOShYFH4FjZWQKBnvKIsOAI=";
  };

  patches = [
    ./load-extensions-from-env.patch
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  buildInputs = [
    glib
    gtk3
    cinnamon-desktop
    libxmlb
    pythonEnv
    xapp
    libexif
    exempi
    gvfs
    libgsf
    json-glib
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wrapGAppsHook3
    intltool
    shared-mime-info
    gobject-introspection
  ];

  mesonFlags = [
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix XDG_DATA_DIRS : "${
         lib.makeSearchPath "share" [
           xapp
           xapp-symbolic-icons
         ]
       }"
       --prefix PATH : "${
         lib.makeBinPath [
           xdg-user-dirs
         ]
       }"
    )
  '';

  passthru.extensiondir = "lib/nemo/extensions-3.0";

  meta = {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
    mainProgram = "nemo";
  };
})
