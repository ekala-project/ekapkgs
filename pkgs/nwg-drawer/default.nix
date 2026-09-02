{
  lib,
  buildGoModule,
  cairo,
  fetchFromGitHub,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
  xdg-utils,
}:

buildGoModule {
  pname = "nwg-drawer";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-drawer";
    rev = "v0.7.5";
    hash = "sha256-G101SX/UjbZaBks8NL2BHps/ydk2EeazyPjb5II9ZLg=";
  };

  vendorHash = "sha256-8PJnDu00/ef7mBAhHgWy/rkpNV1F9JREDP/VRwfK8ck=";

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    gtk-layer-shell
    gtk3
  ];

  preInstall = ''
    mkdir -p $out/share/nwg-drawer
    cp -r desktop-directories drawer.css $out/share/nwg-drawer
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --suffix PATH : ${xdg-utils}/bin
      --prefix XDG_DATA_DIRS : $out/share
    )
  '';

  meta = {
    description = "Application drawer for sway Wayland compositor";
    homepage = "https://github.com/nwg-piotr/nwg-drawer";
    license = lib.licenses.agpl3Plus;
    mainProgram = "nwg-drawer";
    platforms = lib.platforms.linux;
  };
}
