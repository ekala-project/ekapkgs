{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frei0r-plugins";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3gUWvO5izOrJt+XwcNBNiLfu+iMqo4nuPbx++TYzao0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    cairo
  ];

  meta = {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
