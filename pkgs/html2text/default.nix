{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf-archive,
  autoreconfHook,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "html2text";
  version = "2.4.0";

  src = fetchFromGitLab {
    owner = "grobian";
    repo = "html2text";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C229ogU2YStXWizb51whQXc6oSkVnclnOeJYlIMvHWM=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    bison
  ];

  meta = {
    description = "Convert HTML to plain text";
    mainProgram = "html2text";
    homepage = "https://gitlab.com/grobian/html2text";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
