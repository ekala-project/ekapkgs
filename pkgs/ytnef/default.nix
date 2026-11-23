{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytnef";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p8H5f+fKqJ4yvuhjQVlIJ3By6C77ZM0pEHXeGfKeTZk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Yestrday's TNEF stream reader (winmail.dat decoder)";
    homepage = "https://github.com/Yeraze/ytnef";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
