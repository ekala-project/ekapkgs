{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytnef";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kQb45Da0T7wWi1IivA8Whk+ECL2nyFf7Gc0gK1HKj2c=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Yestrday's TNEF stream reader (winmail.dat decoder)";
    homepage = "https://github.com/Yeraze/ytnef";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
