{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  gtk3,
  gettext,
  pango,
  makeWrapper,
  pcre2,
  perl,
  pkg-config,
  vte,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sakura";
  version = "3.8.8";

  src = fetchFromGitHub {
    owner = "dabisu";
    repo = "sakura";
    rev = "SAKURA_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-YeZIYIfFgkK5nxMHq9mslrjIWTRAebhXyzXv5hTmOpI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    makeWrapper
    perl
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    pango
    pcre2
    vte
  ];

  strictDeps = true;

  postFixup = ''
    wrapProgram $out/bin/sakura \
      --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  meta = {
    homepage = "https://www.pleyades.net/david/projects/sakura";
    description = "Terminal emulator based on GTK and VTE";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "sakura";
  };
})
