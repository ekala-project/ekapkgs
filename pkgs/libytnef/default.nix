{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libytnef";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p8H5f+fKqJ4yvuhjQVlIJ3By6C77ZM0pEHXeGfKeTZk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
