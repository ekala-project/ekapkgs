{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
  ncurses,
  jansson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtr";
  version = "0.96";

  src = fetchFromGitHub {
    owner = "traviscross";
    repo = "mtr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Oit0jEm1g+jYCIoTak/mcdlF14GDkDOAWKmX2mYw30M=";
  };

  # we need this before autoreconfHook does its thing
  postPatch = ''
    echo ${finalAttrs.version} > .tarball-version
  '';

  # and this after autoreconfHook has generated Makefile.in
  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace ' install-exec-hook' ""
  '';

  configureFlags = [ "--without-gtk" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    jansson
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libcap;

  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Network diagnostics tool";
    homepage = "https://www.bitwizard.nl/mtr/";
    license = lib.licenses.gpl2Only;
    mainProgram = "mtr";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
