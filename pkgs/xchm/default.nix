{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxwidgets_3_2,
  chmlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xchm";
  version = "1.40";

  src = fetchFromGitHub {
    owner = "rzvncj";
    repo = "xCHM";
    rev = finalAttrs.version;
    sha256 = "sha256-83u13OINHH1poImsyi75mjRZTWu7nvhxKbnF29Cjk0c=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    wxwidgets_3_2
    chmlib
  ];

  configureFlags = [ "--with-wx-prefix=${wxwidgets_3_2}" ];

  preConfigure = ''
    export LDFLAGS="$LDFLAGS $(${wxwidgets_3_2}/bin/wx-config --libs std,aui | sed -e s@-pthread@@)"
  '';

  meta = {
    description = "Viewer for Microsoft HTML Help files";
    homepage = "https://github.com/rzvncj/xCHM";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "xchm";
  };
})
