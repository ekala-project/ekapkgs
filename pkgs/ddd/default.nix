{
  lib,
  stdenv,
  fetchurl,
  imagemagick,
  motif,
  ncurses,
  libx11,
  libxt,
  gdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddd";
  version = "3.4.0";

  src = fetchurl {
    url = "mirror://gnu/ddd/ddd-${finalAttrs.version}.tar.gz";
    hash = "sha256-XUy8iguwRYVDhm1nkwjFOj7wZuQC/loZGOGWmKPTWA8=";
  };

  postPatch = ''
    substituteInPlace ddd/Ddd.in \
      --replace-fail 'debuggerCommand:' 'debuggerCommand: ${gdb}/bin/gdb'
  '';

  nativeBuildInputs = [
    imagemagick
  ];

  buildInputs = [
    motif
    ncurses
    libx11
    libxt
  ];

  configureFlags = [
    "--enable-builtin-manual"
    "--enable-builtin-app-defaults"
  ];

  makeFlags = [ "EXEEXT=exe" ];
  enableParallelBuilding = true;

  postInstall = ''
    mv $out/bin/dddexe $out/bin/ddd
    convert icons/ddd.xbm ddd.png
    install -D ddd.png $out/share/icons/hicolor/48x48/apps/ddd.png
  '';

  meta = {
    changelog = "https://www.gnu.org/software/ddd/news.html";
    description = "Graphical front-end for command-line debuggers";
    homepage = "https://www.gnu.org/software/ddd";
    license = lib.licenses.gpl3Only;
    mainProgram = "ddd";
    platforms = lib.platforms.unix;
  };
})
