{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  pango,
  gdk-pixbuf,
  at-spi2-core,
}:

buildGoModule (finalAttrs: {
  pname = "nwg-menu";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-menu";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3fN89HPwobMiijlvGJ80HexCBdsPLsEvAz9VH8dO4qc=";
  };

  vendorHash = "sha256-5gazNUZdPZh21lcnVFKPSDc/JLi8d6tqfP4NKMzPa8U=";

  doCheck = false;

  buildInputs = [
    at-spi2-core
    gtk3
    gdk-pixbuf
    gtk-layer-shell
    pango
  ];
  nativeBuildInputs = [
    pkg-config
    gtk3.wrapGAppsHook
    gobject-introspection
  ];

  prePatch = ''
    for file in main.go tools.go; do
      substituteInPlace $file --replace '/usr/share/nwg-menu' $out/share
    done
  '';

  postInstall = ''
    mkdir -p $out/share/
    cp menu-start.css $out/share/
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-menu";
    description = "MenuStart plugin for nwg-panel";
    mainProgram = "nwg-menu";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
