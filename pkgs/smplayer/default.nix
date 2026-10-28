{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smplayer";
  version = "26.8.29";

  src = fetchFromGitHub {
    owner = "smplayer-dev";
    repo = "smplayer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5l/vbTQgOkPbahDSKtm/XtRv879nWZ0eWE0bOMNZIc8=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ qt5.qtscript ];

  dontUseQmakeConfigure = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # https://github.com/smplayer-dev/smplayer/issues/1318
  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";

  meta = {
    homepage = "https://www.smplayer.info";
    description = "Complete front-end for MPlayer";
    changelog = "https://github.com/smplayer-dev/smplayer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
# TODO [ ]: create a wrapper including mplayer/mpv
