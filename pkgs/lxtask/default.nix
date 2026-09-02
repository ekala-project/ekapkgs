{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk3,
  intltool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxtask";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxtask";
    tag = finalAttrs.version;
    hash = "sha256-BI50jV/17jGX91rcmg98+gkoy35oNpdSSaVDLyagbIc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  configureFlags = [ "--enable-gtk3" ];

  meta = {
    homepage = "https://lxde.sourceforge.net/";
    description = "Lightweight and desktop independent task manager";
    mainProgram = "lxtask";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
