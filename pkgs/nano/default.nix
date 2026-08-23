{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  ncurses,
  texinfo,
  file ? null,
  gettext ? null,
  enableNls ? true,
  enableTiny ? false,
}:

assert enableNls -> (gettext != null);

let
  nixSyntaxHighlight = fetchFromGitHub {
    owner = "seitz";
    repo = "nanonix";
    rev = "5c30e1de6d664d609ff3828a8877fba3e06ca336";
    hash = "sha256-S9p/g8DZhZ1cZdyFI6eaOxxGAbz+dloFEWdamAHo120=";
  };
in
stdenv.mkDerivation rec {
  pname = "nano";
  version = "9.2";

  src = fetchurl {
    url = "mirror://gnu/nano/nano-${version}.tar.xz";
    hash = "sha256-Bey5kke3guils6Je1BAd0DSwI2kC90SbyXlbcXZC9+k=";
  };

  nativeBuildInputs = [ texinfo ] ++ lib.optional enableNls gettext;
  buildInputs = [ ncurses ] ++ lib.optional (!enableTiny) file;

  outputs = [
    "out"
    "doc"
    "info"
    "man"
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    (lib.enableFeature enableNls "nls")
    (lib.enableFeature enableTiny "tiny")
  ];

  postInstall =
    if enableTiny then
      null
    else
      ''
        cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
      '';

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;
  strictDeps = true;

  meta = {
    homepage = "https://www.nano-editor.org/";
    description = "Small, user-friendly console text editor";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "nano";
  };
}
