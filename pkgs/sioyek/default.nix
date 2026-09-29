{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  mujs,
  mupdf,
  openjpeg,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sioyek";
  version = "2.0.0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = "sioyek";
    rev = "9db073128bb5c4656d2403b8a3cc5b70138cf2f6";
    hash = "sha256-EJWo7eHp0ls1PZZQZ3zF1oSzm+BcfZMVFLqeYtwHC2o=";
  };

  buildInputs = [
    gumbo
    harfbuzz
    jbig2dec
    mujs
    mupdf
    openjpeg
    qt6.qt3d
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtspeech
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ freetype ];

  nativeBuildInputs = [
    installShellFiles
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  qmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "CONFIG+=non_portable" ];

  # With structuredAttrs/strictDeps, envBuildHostHooks (which sets QMAKEPATH)
  # only fires for nativeBuildInputs. We need to add Qt modules from
  # buildInputs to QMAKEPATH so qmake can find them.
  preConfigure = ''
    for dep in ${qt6.qt3d} ${qt6.qtdeclarative} ${qt6.qtmultimedia} ${qt6.qtspeech} ${qt6.qtsvg}; do
      if [ -d "$dep/mkspecs" ]; then
        QMAKEPATH="''${QMAKEPATH:+$QMAKEPATH:}$dep"
      fi
    done
  '';

  postPatch = ''
    substituteInPlace pdf_viewer_build_config.pro \
      --replace-fail "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2" \
      --replace-fail "-lmupdf-third" ""
    substituteInPlace pdf_viewer/main.cpp \
      --replace-fail "/usr/share/sioyek" "$out/share" \
      --replace-fail "/etc/sioyek" "$out/etc"
  '';

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
        cp pdf_viewer/{prefs,prefs_user,keys,keys_user}.config tutorial.pdf sioyek.app/Contents/MacOS/

        mkdir -p $out/Applications $out/bin
        cp -r sioyek.app $out/Applications
        ln -s $out/Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek
      ''
    else
      ''
        install -Dm644 tutorial.pdf $out/share/tutorial.pdf
        cp -r pdf_viewer/shaders $out/share/
        install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
        installManPage resources/sioyek.1
      '';

  meta = {
    homepage = "https://sioyek.info/";
    description = "PDF viewer designed for research papers and technical books";
    mainProgram = "sioyek";
    changelog = "https://github.com/ahrm/sioyek/releases";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
