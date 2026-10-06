{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:

let
  pname = "zettlr";
  version = "4.8.0";

  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    hash = "sha256-DICsOp5ojOmcLJoFJU2vMqr5qqxKQPIwfmlevpjQvfs=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/zettlr \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/Zettlr.desktop $out/share/applications/Zettlr.desktop
    install -m 444 -D ${appimageContents}/Zettlr.png $out/share/icons/hicolor/512x512/apps/Zettlr.png
    substituteInPlace $out/share/applications/Zettlr.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
    mainProgram = "zettlr";
  };
}
