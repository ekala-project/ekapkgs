{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  pcre2,
  glib,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  gettext,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fsearch";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = "fsearch";
    rev = finalAttrs.version;
    hash = "sha256-IdcNjlloyJEGZ1BbGxaeLGUiDhrku9fIXM45LwQ8iRc=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
    gettext
  ];

  buildInputs = [
    glib
    gtk3
    pcre2
    icu
  ];

  preFixup = ''
    substituteInPlace $out/share/applications/io.github.cboxdoerfer.FSearch.desktop \
      --replace "Exec=fsearch" "Exec=$out/bin/fsearch"
  '';

  meta = {
    description = "Fast file search utility for Unix-like systems based on GTK+3";
    homepage = "https://github.com/cboxdoerfer/fsearch.git";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "fsearch";
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/fsearch.x86_64-darwin
  };
})
