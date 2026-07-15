{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libiconv,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zvbi";
  version = "0.2.44";

  src = fetchFromGitHub {
    owner = "zapping-vbi";
    repo = "zvbi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-knc9PejugU6K4EQflfz91keZr3ZJqZu2TKFQFFJrxiI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    libiconv
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Vertical Blanking Interval (VBI) utilities";
    homepage = "https://github.com/zapping-vbi/zvbi";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
