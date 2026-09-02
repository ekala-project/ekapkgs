{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "ctags";
  version = "816";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/ctags/code/trunk";
    rev = version;
    sha256 = "0jmbkrmscbl64j71qffcc39x005jrmphx8kirs1g2ws44wil39hf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--enable-tmpdir=/tmp" ];

  patches = [
    ./unused-collision.patch
  ];

  meta = {
    description = "Tool for fast source code browsing (exuberant ctags)";
    mainProgram = "ctags";
    homepage = "https://ctags.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    priority = 1;
  };
}
