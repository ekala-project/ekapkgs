{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pandoc ? null,
  pkg-config,
  openssl,
  installShellFiles,
  copyDesktopItems,
  makeDesktopItem,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fend";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = "fend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XIdz7s8DCmXSeFIC06C+/wLDyMBcqIrjDSQUAhxX72s=";
  };

  cargoHash = "sha256-mDsAZvnBGXhEl2Qbww2svPznl6k9b44zGdMkeejIWVU=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optional (pandoc != null) pandoc;

  buildInputs = [
    pkg-config
    openssl
  ];

  postBuild = lib.optionalString (pandoc != null) ''
    patchShebangs --build ./documentation/build.sh
    ./documentation/build.sh
  '';

  preFixup = lib.optionalString (pandoc != null) ''
    installManPage documentation/fend.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  postInstall = ''
    install -D -m 444 $src/icon/icon.svg $out/share/icons/hicolor/scalable/apps/fend.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fend";
      desktopName = "fend";
      genericName = "Calculator";
      comment = "Arbitrary-precision unit-aware calculator";
      icon = "fend";
      exec = "fend";
      terminal = true;
      categories = [
        "Utility"
        "Calculator"
        "ConsoleOnly"
      ];
    })
  ];

  meta = {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    changelog = "https://github.com/printfn/fend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "fend";
  };
})
