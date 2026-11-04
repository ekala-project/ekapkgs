{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  gtk3,
  gtksourceview,
  gtkspell3,
  poppler,
  texlive,
  pkg-config,
  intltool,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.8.3";
  pname = "gummi";

  src = fetchFromGitHub {
    owner = "alexandervdm";
    repo = "gummi";
    rev = finalAttrs.version;
    sha256 = "sha256-71n71KjLmICp4gznd27NlbyA3kayje3hYk/cwkOXEO0=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    autoreconfHook
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtksourceview
    gtk3
    gtkspell3
    poppler
    texlive.bin.core
  ];

  postInstall = ''
    install -Dpm644 COPYING $out/share/licenses/$name/COPYING
  '';

  meta = {
    homepage = "https://gummi.app";
    description = "Simple LaTex editor for GTK users";
    mainProgram = "gummi";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
