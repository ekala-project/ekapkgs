{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  diffutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colordiff";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "daveewart";
    repo = "colordiff";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZFxBY/QrKlRC7glEGWpB/79Jup0e4RCnS82Ct6lhK4Y=";
  };

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TMPDIR=colordiff-''${VERSION}' ""

    substituteInPlace colordiff.pl \
      --replace '= "diff";' '= "${diffutils}/bin/diff";'

  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/etc
    install -m 755 colordiff.pl $out/bin/colordiff
    install -m 755 cdiff.sh $out/bin/cdiff
    install -m 644 colordiffrc $out/etc/colordiffrc
    runHook postInstall
  '';

  meta = {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = "https://www.colordiff.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "colordiff";
  };
})
