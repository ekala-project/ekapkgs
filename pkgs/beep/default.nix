{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beep";
  version = "1.4.12";

  src = fetchFromGitHub {
    owner = "spkr-beep";
    repo = "beep";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gDgGI9F+wW2cN89IwP93PkMv6vixJA2JckF78nxZ+TU=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = {
    description = "Advanced PC speaker beeper";
    homepage = "https://github.com/spkr-beep/beep";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "beep";
  };
})
