{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages ? { },
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  gsettings-desktop-schemas,
  enableX11 ? (!stdenv.hostPlatform.isDarwin && (ocamlPackages ? lablgtk3)),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison";
  version = "2.54.0";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    tag = "v${finalAttrs.version}";
    hash = "sha256-48d+HuFuhjztWz0aoi6DNlBPrV9J05/jjBofXY1PVBg=";
  };

  # Allow the build scripts to correctly call ocamlfind & detect dependencies
  patches = [ ./fix-ocamlfind-env.patch ];

  strictDeps = true;

  nativeBuildInputs =
    lib.optional (ocamlPackages ? ocaml) ocamlPackages.ocaml
    ++ lib.optional (ocamlPackages ? findlib) ocamlPackages.findlib
    ++ lib.optionals enableX11 [
      copyDesktopItems
      gtk3.wrapGAppsHook
    ];

  buildInputs = lib.optionals enableX11 [
    gsettings-desktop-schemas
    ocamlPackages.lablgtk3
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optionals (!(ocamlPackages.ocaml.nativeCompilers or true)) [ "NATIVE=false" ];

  postInstall = lib.optionalString enableX11 ''
    install -D $src/icons/U.svg $out/share/icons/hicolor/scalable/apps/unison.svg
  '';

  dontStrip = !(ocamlPackages.ocaml.nativeCompilers or true);

  desktopItems = lib.optional enableX11 (makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "Unison";
    comment = "Bidirectional file synchronizer";
    genericName = "File synchronization tool";
    exec = "unison-gui";
    icon = "unison";
    categories = [
      "Utility"
      "FileTools"
      "GTK"
    ];
    startupNotify = true;
    startupWMClass = "Unison";
  });

  meta = {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin && enableX11;
    mainProgram = if enableX11 then "unison-gui" else "unison";
  };
})
