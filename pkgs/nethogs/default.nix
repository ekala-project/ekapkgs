{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nethogs";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = "nethogs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+yVMyGSBIBWYjA9jaGWvrcsNPbJ6S4ax9H1BhWHYUUU=";
  };

  buildInputs = [
    ncurses
    libpcap
  ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "nethogs"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "sbin=$(out)/bin"
  ];

  meta = {
    description = "Small 'net top' tool, grouping bandwidth by process";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/raboof/nethogs#readme";
    platforms = lib.platforms.linux;
    mainProgram = "nethogs";
    maintainers = [ ];
  };
})
