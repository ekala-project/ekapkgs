{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook3,
  pkg-config,
  appstream-glib,
  json-glib,
  desktop-file-utils,
  gtk3,
  girara,
  gettext,
  libxml2,
  check,
  sqlite,
  glib,
  libintl,
  libseccomp,
  file,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura";
  version = "2026.05.20";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura";
    tag = finalAttrs.version;
    hash = "sha256-ChrIJKPVukkW6d/grGcMJ6sZ9sctIOmyJv6TAehh1T8=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  mesonFlags = [
    "-Dmanpages=disabled"
    "-Dconvert-icon=disabled"
    "-Dsynctex=disabled"
    "-Dtests=disabled"
    "-Dsysconfdir=/etc"
    (lib.mesonEnable "seccomp" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "landlock" stdenv.hostPlatform.isLinux)
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    desktop-file-utils
    gettext
    wrapGAppsHook3
    libxml2
    appstream-glib
  ];

  buildInputs = [
    gtk3
    girara
    libintl
    sqlite
    glib
    file
    librsvg
    check
    json-glib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libseccomp;

  doCheck = false;

  meta = {
    homepage = "https://pwmt.org/projects/zathura";
    description = "Core component for zathura PDF viewer";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "zathura";
  };
})
