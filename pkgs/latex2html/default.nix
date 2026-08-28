{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ghostscript,
  netpbm,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "latex2html";
  version = "2025";

  src = fetchFromGitHub {
    owner = "latex2html";
    repo = "latex2html";
    rev = "v${version}";
    sha256 = "sha256-xylIU2GY/1t9mA8zJzEjHwAIlvVxZmUAUdQ/IXEy+Wg=";
  };

  buildInputs = [
    ghostscript
    netpbm
    perl
  ];

  nativeBuildInputs = [ makeWrapper ];

  configurePhase = ''
    ./configure \
      --prefix="$out" \
      --without-mktexlsr \
      --with-texpath=$out/share/texmf/tex/latex/html
  '';

  postInstall = ''
    for p in $out/bin/{latex2html,pstoimg}; do \
      wrapProgram $p --add-flags '--tmp="''${TMPDIR:-/tmp}"'
    done
  '';

  meta = {
    description = "LaTeX-to-HTML translator";
    homepage = "https://www.ctan.org/pkg/latex2html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
