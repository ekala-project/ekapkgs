{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  libfontenc,
  freetype,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fonttosfnt";
  version = "1.2.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "fonttosfnt";
    tag = "fonttosfnt-${finalAttrs.version}";
    hash = "sha256-W516e6ChCyvyjW4AT5DKzg12s+up0fO5UMDedAcO68o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
  ];

  buildInputs = [
    libfontenc
    freetype
    xorgproto
  ];

  meta = {
    description = "Wraps a set of bdf or pcf bitmap fonts in a sfnt (TrueType or OpenType) wrapper";
    homepage = "https://gitlab.freedesktop.org/xorg/app/fonttosfnt";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "fonttosfnt";
  };
})
