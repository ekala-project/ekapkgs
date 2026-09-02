{
  lib,
  stdenv,
  fetchurl,
  libxext,
  libxaw3d,
  ghostscript,
  perl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gv";
  version = "3.7.4";

  src = fetchurl {
    url = "mirror://gnu/gv/gv-${version}.tar.gz";
    sha256 = "0q8s43z14vxm41pfa8s5h9kyyzk1fkwjhkiwbf2x70alm6rv6qi1";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxext
    libxaw3d
    ghostscript
    perl
  ];

  patchPhase = ''
    sed 's|\<gs\>|${ghostscript}/bin/gs|g' -i "src/"*.in
    sed 's|"gs"|"${ghostscript}/bin/gs"|g' -i "src/"*.c
  '';

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/gv/";
    description = "PostScript/PDF document viewer";
    longDescription = ''
      GNU gv allows users to view and navigate through PostScript and
      PDF documents on an X display by providing a graphical user
      interface for the Ghostscript interpreter.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
