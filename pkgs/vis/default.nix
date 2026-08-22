{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  ncurses,
  libtermkey,
  lua,
  tre,
  acl,
  libselinux,
}:

stdenv.mkDerivation rec {
  pname = "vis";
  version = "0.9";

  src = fetchFromGitHub {
    rev = "v${version}";
    hash = "sha256-SYM3zlzhp3NdyOjtXc+pOiWY4/WA/Ax+qAWe18ggq3g=";
    repo = "vis";
    owner = "martanne";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    ncurses
    libtermkey
    lua
    tre
    acl
    libselinux
  ];

  postInstall = ''
    wrapProgram $out/bin/vis \
      --prefix VIS_PATH : "\$HOME/.config:$out/share/vis"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vis";
      exec = "vis %U";
      type = "Application";
      icon = "accessories-text-editor";
      comment = meta.description;
      desktopName = "vis";
      genericName = "Text editor";
      categories = [
        "Application"
        "Development"
        "IDE"
      ];
      mimeTypes = [
        "text/plain"
        "application/octet-stream"
      ];
      startupNotify = false;
      terminal = true;
    })
  ];

  meta = {
    description = "Vim like editor";
    homepage = "https://github.com/martanne/vis";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "vis";
  };
}
