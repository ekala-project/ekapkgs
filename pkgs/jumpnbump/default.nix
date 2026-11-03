{
  lib,
  stdenv,
  fetchFromGitLab,
  sdl2-compat,
  SDL2_mixer,
  SDL2_net,
  gtk3,
  gobject-introspection,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "jumpnbump";
  version = "1.70-dev";

  # By targeting the development version, we can omit the patches Arch uses
  src = fetchFromGitLab {
    owner = "LibreGames";
    repo = "jumpnbump";
    rev = "5744738211ca691444f779aafee3537fb3562516";
    sha256 = "0f1k26jicmb95bx19wgcdpwsbbl343i7mqqqc2z9lkb8drlsyqcy";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    python3Packages.wrapPython
    gtk3.wrapGAppsHook
    gobject-introspection
    sdl2-compat
    SDL2_mixer
    SDL2_net
  ];

  buildInputs = [
    sdl2-compat
    SDL2_mixer
    SDL2_net
    gtk3
  ];

  postInstall = ''
    make -C menu PREFIX=$out all install
    # additional-levels.tar.xz source (pagesperso-orange.fr) is no longer available
    rm $out/share/applications/jumpnbump-menu.desktop
    sed -i -e 's+Exec=jumpnbump+Exec=jumpnbump-menu+' $out/share/applications/jumpnbump.desktop
  '';

  pythonPath = with python3Packages; [
    pygobject3
    pillow
  ];
  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "Cute, true multiplayer platform game with bunnies";
    homepage = "https://libregames.gitlab.io/jumpnbump/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    broken = true; # needs SDL2_net 2.x, we have 3.x (SDL3_net)
  };
}
