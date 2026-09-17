{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsNoGuiHook,
  itstool,
  gettext,
  glib,
  coreutils,
  accountsservice,
  dbus,
  pam,
  polkit,
  glib-testing,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "malcontent";
  version = "0.13.1";

  outputs = [
    "bin"
    "out"
    "lib"
    "pam"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "malcontent";
    rev = version;
    hash = "sha256-ekRi4yXu8u8t1AjyS3bD6tdqqnqtKyI6yZs+28LnfRY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsNoGuiHook
    itstool
    gettext
  ];

  buildInputs = [
    accountsservice
    dbus
    pam
    polkit
    glib-testing
    (python3.withPackages (
      pp: with pp; [
        pygobject3
      ]
    ))
  ];

  propagatedBuildInputs = [
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dinstalled_tests=false"
    "-Dpamlibdir=${placeholder "pam"}/lib/security"
    "-Dui=disabled"
  ];

  postPatch = ''
    substituteInPlace libmalcontent/tests/app-filter.c \
      --replace-fail "/usr/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/bin/true" "${coreutils}/bin/true" \
      --replace-fail "/usr/bin/false" "${coreutils}/bin/false" \
      --replace-fail "/bin/false" "${coreutils}/bin/false"
  '';

  postInstall = ''
    addToSearchPath GI_TYPELIB_PATH "$lib/lib/girepository-1.0"
  '';

  meta = {
    outputsToInstall = [
      "bin"
      "out"
    ];
    description = "Parental controls library";
    mainProgram = "malcontent-client";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
