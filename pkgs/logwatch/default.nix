{
  lib,
  stdenv,
  fetchurl,
  perl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logwatch";
  version = "7.11";

  src = fetchurl {
    url = "mirror://sourceforge/logwatch/logwatch-${finalAttrs.version}.tar.gz";
    hash = "sha256-XrQtmDqWZwAzaLVyFJ/OeIwNfhParx8orRvzoUC4Zc8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,etc/logwatch,share/logwatch}
    cp -a conf/* $out/etc/logwatch/
    cp -a scripts/* $out/share/logwatch/
    cp -a lib $out/share/logwatch/

    install -Dm755 scripts/logwatch.pl $out/bin/logwatch

    wrapProgram $out/bin/logwatch \
      --prefix PERL5LIB : "${perl}/lib/perl5" \
      --set LOGWATCH_CONF_DIR $out/etc/logwatch \
      --set LOGWATCH_SCRIPT_DIR $out/share/logwatch

    runHook postInstall
  '';

  meta = {
    description = "System log analyzer and reporter";
    homepage = "https://sourceforge.net/projects/logwatch/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "logwatch";
  };
})
