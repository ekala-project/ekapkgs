{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  python3,
  glib-networking,
  asciidoc,
  docbook-xml-dtd,
  docbook_xsl,
  libxml2,
  libxslt,
  withPdfReader ? true,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pipewire,
  qt6Packages,
  wayland,
  enableWideVine ? false,
  widevine-cdm ? null,
  # can cause issues on some graphics chips
  enableVulkan ? false,
  vulkan-loader,
}:

let
  pdfjs =
    let
      version = "5.6.205";
    in
    fetchzip {
      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
      hash = "sha256-JMmxoT68PNJ/MmlMwVNYcHerorklLv5YY6C55xjn73w=";
      stripRoot = false;
    };

  version = "3.7.0";
in

python3.pkgs.buildPythonApplication {
  pname = "qutebrowser";
  inherit version;
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/qutebrowser-${version}.tar.gz";
    hash = "sha256-x/lYhOpeZnXlhAJb6lXP+VDEfXSa/39BX2jaA/zOD5I=";
  };

  buildInputs = [
    qt6Packages.qtbase
    glib-networking
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6Packages.qtwayland
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    asciidoc
    docbook-xml-dtd.v4_5
    docbook_xsl
    libxml2
    libxslt
  ];

  dependencies =
    let
      p = python3.pkgs;
    in
    lib.filter (x: x != null) [
      (p.colorama or null)
      (p.pyyaml or null)
      (p.pyqt6-webengine or null)
      (p.jinja2 or null)
      (p.pygments or null)
      # scripts and userscripts libs
      (p.tldextract or null)
      (p.beautifulsoup4 or null)
      (p.readability-lxml or null)
      (p.pykeepass or null)
      (p.stem or null)
      (p.pynacl or null)
      # extensive ad blocking
      (p.adblock or null)
      # for the qute-bitwarden user script to be able to copy the TOTP token to clipboard
      (p.pyperclip or null)
    ];

  patches = [
    ./fix-restart.patch
  ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr,$out,g" qutebrowser/utils/standarddir.py
  ''
  + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  ''
  + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform wayland) ''
    substituteInPlace qutebrowser/misc/wmname.py \
      --replace-fail '_load_library("wayland-client")' \
                     'ctypes.CDLL("${lib.getLib wayland}/lib/libwayland-client${stdenv.hostPlatform.extensions.sharedLibrary}")'
  '';

  installPhase = ''
    runHook preInstall

    make -f misc/Makefile \
      PYTHON=${(python3.pythonOnBuildForHost.withPackages (ps: with ps; [ setuptools ])).interpreter} \
      PREFIX=. \
      DESTDIR="$out" \
      DATAROOTDIR=/share \
      install

    runHook postInstall
  '';

  postInstall = ''
    # Patch python scripts
    buildPythonPath "$out $propagatedBuildInputs"
    scripts=$(grep -rl python "$out"/share/qutebrowser/{user,}scripts/)
    for i in $scripts; do
      patchPythonScript "$i"
    done
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [ pipewire ];
      resourcesPath =
        if stdenv.hostPlatform.isDarwin then
          "${qt6Packages.qtwebengine}/lib/QtWebEngineCore.framework/Resources"
        else
          "${qt6Packages.qtwebengine}/resources";
    in
    ''
      makeWrapperArgs+=(
        # Force the app to use QT_PLUGIN_PATH values from wrapper
        --unset QT_PLUGIN_PATH
        "''${qtWrapperArgs[@]}"
        # avoid persistant warning on starup
        --set QT_STYLE_OVERRIDE Fusion
        ${lib.optionalString pipewireSupport "--prefix LD_LIBRARY_PATH : ${libPath}"}
        ${lib.optionalString enableVulkan ''
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
          --set-default QSG_RHI_BACKEND vulkan
        ''}
        ${lib.optionalString enableWideVine ''--add-flags "--qt-flag widevine-path=${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"''}
        --set QTWEBENGINE_RESOURCES_PATH "${resourcesPath}"
      )
    '';

  meta = {
    homepage = "https://github.com/qutebrowser/qutebrowser";
    changelog = "https://github.com/qutebrowser/qutebrowser/blob/v${version}/doc/changelog.asciidoc";
    description = "Keyboard-focused browser with a minimal GUI";
    license = lib.licenses.gpl3Plus;
    mainProgram = "qutebrowser";
    platforms = if enableWideVine then [ "x86_64-linux" ] else qt6Packages.qtwebengine.meta.platforms;
  };
}
