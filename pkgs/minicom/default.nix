{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minicom";
  version = "2.10";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "minicom-team";
    repo = "minicom";
    rev = finalAttrs.version;
    sha256 = "sha256-wC6VlMRwuhV1zQ26wNx7gijuze8E2CvnzpqOSIPzq2s=";
  };

  buildInputs = [
    ncurses
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--sysconfdir=/etc"
    "--enable-lock-dir=/var/lock"
  ];

  patches = [ ./xminicom_terminal_paths.patch ];

  preConfigure = ''
    substituteInPlace configure \
      --replace 'test -d $UUCPLOCK' true
  '';

  meta = {
    description = "Modem control and terminal emulation program";
    homepage = "https://salsa.debian.org/minicom-team/minicom";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
