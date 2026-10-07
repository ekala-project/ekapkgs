{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flea";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "thisisgm";
    repo = "flea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/IrUD/pNXD396dMaQrQ8RwcSRsqeqVKFm6jXkaI3CWg=";
  };

  cargoHash = "sha256-BbFN/3fzKX+KNS+jabWFTTZDHS3uVjybGKZ1uR7Cz54=";

  doCheck = false;

  postInstall = ''
    install -Dm755 tools/flea-gio-auth "$out/lib/flea/flea-gio-auth"
    install -Dm755 tools/flea-portal "$out/lib/flea/flea-portal"
    install -Dm755 tools/flea-filemanager1 "$out/lib/flea/flea-filemanager1"

    install -Dm644 packaging/flea.portal -t "$out/share/xdg-desktop-portal/portals"
    install -Dm644 packaging/org.freedesktop.impl.portal.desktop.flea.service -t "$out/share/dbus-1/services"
    install -Dm644 packaging/com.thisisgm.flea.FileManager1.service -t "$out/share/dbus-1/services"
    install -Dm644 packaging/com.thisisgm.flea.desktop -t "$out/share/applications"
    install -Dm644 packaging/com.thisisgm.flea.svg -t "$out/share/icons/hicolor/scalable/apps"

    install -Dm644 ui/qmldir ui/*.qml ui/*.js -t "$out/share/flea/ui"
    install -Dm644 ui/js/*.js ui/js/*.mjs -t "$out/share/flea/ui/js"
    install -Dm644 ui/vendor/*.mjs -t "$out/share/flea/ui/vendor"
    install -Dm644 ui/vendor/LICENSES/* -t "$out/share/flea/ui/vendor/LICENSES"
    install -Dm644 ui/boot/shell.qml ui/boot/picker.qml ui/boot/fleatab.qml ui/boot/tabtearoff.qml -t "$out/share/flea/ui/boot"
    install -Dm644 shelf/manifest.json shelf/README.md shelf/*.qml shelf/*.js -t "$out/share/flea/shelf"
  '';

  meta = {
    description = "Fast, keyboard-first file manager for Omarchy";
    homepage = "https://github.com/thisisgm/flea";
    license = with lib.licenses; [ mit asl20 epl20 bsd2 ];
    platforms = lib.platforms.linux;
    mainProgram = "flea";
  };
})
