{
  stdenv,
  fetchFromGitHub,
  lib,
  autoreconfHook,
  help2man,
}:

stdenv.mkDerivation {
  pname = "libiff";
  version = "0-unstable-2024-03-02";
  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libiff";
    rev = "b5f542a83c824f26e0816770c9a17c22bd388606";
    hash = "sha256-Arh3Ihd5TWg5tdemodrxz2EDxh/hwz9b2/AvrTONFy8=";
  };
  nativeBuildInputs = [
    autoreconfHook
  ];

  # help2man fails to run libtool-wrapped binaries during build;
  # remove man page generation rules
  postPatch = ''
    for f in src/iffjoin/Makefile.am src/iffpp/Makefile.am; do
      sed -i '/HELP2MAN/d; /man1_MANS/d; /\.1:/d; /EXTRA_DIST.*\.1/d' "$f"
    done
  '';
  meta = {
    description = "Parser for the Interchange File Format (IFF)";
    longDescription = ''
      libiff is a portable, extensible parser library implemented in
      ANSI C, for EA-IFF 85: Electronic Arts' Interchange File Format
      (IFF).
    '';
    homepage = "https://github.com/svanderburg/libiff";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
}
