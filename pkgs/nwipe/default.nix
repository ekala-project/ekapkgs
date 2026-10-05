{
  lib,
  stdenv,
  autoreconfHook,
  makeWrapper,
  fetchFromGitHub,
  ncurses,
  parted,
  pkg-config,
  libconfig,
  libnvme,
  hdparm,
  smartmontools,
  dmidecode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nwipe";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Z9Grptk+wlTIh46mXY38JdTK4wr+J3W+CD6ZH0YrZXs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    ncurses
    parted
    libconfig
    libnvme
  ];

  postInstall = ''
    wrapProgram $out/bin/nwipe \
      --prefix PATH : ${
        lib.makeBinPath [
          hdparm
          smartmontools
          dmidecode
        ]
      }
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Securely erase disks";
    mainProgram = "nwipe";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
