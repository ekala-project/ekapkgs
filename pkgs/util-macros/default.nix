{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  autoreconfHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "util-macros";
  version = "1.20.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "macros";
    tag = "util-macros-${finalAttrs.version}";
    hash = "sha256-COIWe7GMfbk76/QUIRsN5yvjd6MEarI0j0M+Xa0WoKQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "GNU autoconf macros shared across X.Org projects";
    homepage = "https://gitlab.freedesktop.org/xorg/util/macros";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
