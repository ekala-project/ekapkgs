{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  gtk3,
  libx11,
  cmake,
  ninja,
  imagemagick,
  pkg-config,
  perl,
  halibut,
  isMobile ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sgt-puzzles";
  version = "20260923.616da16";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${finalAttrs.version}.tar.gz";
    hash = "sha256-zEGcgGC04ivjmKoD4wZR+84Ubu5RBkXDA/tvXxt3t44=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    desktop-file-utils
    imagemagick
    perl
    pkg-config
    gtk3.wrapGAppsHook
    halibut
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString isMobile "-DSTYLUS_BASED";

  buildInputs = [
    gtk3
    libx11
  ];

  postInstall = ''
    for i in  $(basename -s $out/bin/*); do

      ln -s $out/bin/$i $out/bin/sgt-puzzle-$i
      install -Dm644 icons/$i-96d24.png -t $out/share/icons/hicolor/96x96/apps/

      echo "[Desktop Entry]" > $i.desktop
      desktop-file-install --dir $out/share/applications \
        --set-key Type --set-value Application \
        --set-key Exec --set-value $i \
        --set-key Name --set-value $i \
        --set-key Comment --set-value "${finalAttrs.meta.description}" \
        --set-key Categories --set-value "Game;LogicGame;X-sgt-puzzles;" \
        --set-key Icon --set-value $out/share/icons/hicolor/96x96/apps/$i-96d24.png \
        $i.desktop
    done
  '';

  meta = {
    description = "Simon Tatham's portable puzzle collection";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/";
  };
})
