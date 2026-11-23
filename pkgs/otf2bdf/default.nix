{
  lib,
  stdenv,
  fetchFromGitHub,
  freetype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otf2bdf";
  version = "3.1_p1";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "otf2bdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8z1uqUhUPK+fMW3PLkvF3eSlSJpo0x+6NQ6vYsEMqoM=";
  };

  buildInputs = [ freetype ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install otf2bdf $out/bin
    cp otf2bdf.man $out/share/man/man1/otf2bdf.1
  '';

  meta = {
    homepage = "https://github.com/jirutka/otf2bdf";
    description = "OpenType to BDF font converter";
    license = lib.licenses.mit0;
    platforms = lib.platforms.all;
    mainProgram = "otf2bdf";
  };
})
