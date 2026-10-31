{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  qt5,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "puddletag";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "puddletag";
    repo = "puddletag";
    tag = finalAttrs.version;
    hash = "sha256-Per+olIi2yd2cNRO22Fi6cC7/90AqRP1NpRK1XU1i0A=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "chromaprint"
    "pyqt5-qt5"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail share/pixmaps share/icons
  '';

  buildInputs =
    with qt5;
    [
      qtbase
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt5.qtwayland
    ];

  nativeBuildInputs = with qt5; [
    wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    configobj
    levenshtein
    lxml
    mutagen
    pyacoustid
    pyparsing
    pyqt5
    rapidfuzz
    unidecode
  ];

  preFixup = ''
    chmod 555 $out/bin/puddletag
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;
  dontWrapQtApps = true;
  dontStrip = true;

  meta = {
    description = "Audio tag editor similar to the Windows program, Mp3tag";
    mainProgram = "puddletag";
    homepage = "https://docs.puddletag.net";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
