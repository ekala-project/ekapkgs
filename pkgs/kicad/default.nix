{
  lib,
  stdenv,
  runCommand,
  fetchFromGitLab,
  makeWrapper,
  symlinkJoin,
  callPackage,
  callPackages,
  adwaita-icon-theme,
  dconf,
  gtk3,
  wxwidgets,
  webkitgtk,
  librsvg,
  cups,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
  python3,
  with3d ? false,
  withI18n ? true,
}:
let
  versionsImport = import ./versions.nix;
  baseName = "kicad";

  kicadSrcFetch = fetchFromGitLab {
    group = "kicad";
    owner = "code";
    repo = "kicad";
    rev = versionsImport.${baseName}.kicadVersion.src.rev;
    sha256 = versionsImport.${baseName}.kicadVersion.src.sha256;
  };

  libSrcFetch =
    name:
    fetchFromGitLab {
      group = "kicad";
      owner = "libraries";
      repo = "kicad-${name}";
      rev = versionsImport.${baseName}.libVersion.libSources.${name}.rev;
      sha256 = versionsImport.${baseName}.libVersion.libSources.${name}.sha256;
    };

  kicadSrc = kicadSrcFetch;
  kicadVersion = versionsImport.${baseName}.kicadVersion.version;
  libSrc = name: libSrcFetch name;

  # KiCad requires wxWidgets with webview support
  wxGTK = wxwidgets.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ webkitgtk ];
    configureFlags = builtins.map (f: if f == "--disable-webview" then "--enable-webview" else f) (
      old.configureFlags or [ ]
    );
  });
  python = python3;
in
stdenv.mkDerivation rec {
  pname = "kicad";
  version = kicadVersion;

  passthru.libraries = callPackages ./libraries.nix {
    inherit libSrc;
  };

  base = callPackage ./base.nix {
    inherit kicadSrc kicadVersion;
    inherit wxGTK python;
    withScripting = false;
    inherit withI18n;
  };

  src = base;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ makeWrapper ];

  template_dir = symlinkJoin {
    name = "KiCad_template_dir";
    paths = with passthru.libraries; [
      "${templates}/share/kicad/template"
      "${footprints}/share/kicad/template"
      "${symbols}/share/kicad/template"
    ];
  };

  baseWithTemplate = runCommand "kicad-stock-data" { } ''
    mkdir -p $out
    for d in ${base}/share/kicad/*; do
      name=$(basename "$d")
      [ "$name" = template ] || ln -s "$d" "$out/$name"
    done
    ln -s ${template_dir} $out/template
  '';

  stockDataPath = baseWithTemplate;

  makeWrapperArgs =
    with passthru.libraries;
    [
      "--prefix XDG_DATA_DIRS : ${base}/share"
      "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
      "--prefix XDG_DATA_DIRS : ${adwaita-icon-theme}/share"
      "--prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}"
      "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      "--prefix XDG_DATA_DIRS : ${cups}/share"
      "--prefix GIO_EXTRA_MODULES : ${dconf}/lib/gio/modules"
      "--set-default MOZ_DBUS_REMOTE 1"
      "--set-default KICAD10_FOOTPRINT_DIR ${footprints}/share/kicad/footprints"
      "--set-default KICAD10_SYMBOL_DIR ${symbols}/share/kicad/symbols"
      "--set-default KICAD10_TEMPLATE_DIR ${template_dir}"
      "--set-default NIX_KICAD10_STOCK_DATA_PATH ${stockDataPath}"
    ]
    ++ [ "--set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ];

  installPhase =
    let
      tools = [
        "kicad"
        "pcbnew"
        "eeschema"
        "gerbview"
        "pcb_calculator"
        "pl_editor"
        "bitmap2component"
        "kicad-cli"
      ];
      utils = [
        "dxf2idf"
        "idf2vrml"
        "idfcyl"
        "idfrect"
      ];
    in
    lib.concatStringsSep "\n" (
      lib.flatten [
        "runHook preInstall"
        (map (tool: "makeWrapper ${base}/bin/${tool} $out/bin/${tool} $makeWrapperArgs") tools)
        (map (util: "ln -s ${base}/bin/${util} $out/bin/${util}") utils)
        "runHook postInstall"
      ]
    );

  postInstall = ''
    mkdir -p $out/share
    ln -s ${base}/share/applications $out/share/applications
    ln -s ${base}/share/icons $out/share/icons
    ln -s ${base}/share/mime $out/share/mime
    ln -s ${base}/share/metainfo $out/share/metainfo
  '';

  meta = {
    description = "Open Source Electronics Design Automation suite";
    homepage = "https://www.kicad.org/";
    longDescription = ''
      KiCad is an open source software suite for Electronic Design Automation.
      The Programs handle Schematic Capture, and PCB Layout with Gerber output.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kicad";
  };
}
