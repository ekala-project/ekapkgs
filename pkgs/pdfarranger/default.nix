{
  fetchFromGitHub,
  lib,
  gtk3,
  python3Packages,
  poppler,
  libhandy,
  gettext,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pdfarranger";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfarranger";
    repo = "pdfarranger";
    tag = finalAttrs.version;
    hash = "sha256-vucl04ltyAFUhwGlFfNnLEyvX2SACEt0WCG3t4QLuxc=";
  };

  nativeBuildInputs = [
    gtk3.wrapGAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    LINTL="${lib.getLib gettext}/lib/libintl.8.dylib"
    substituteInPlace pdfarranger/pdfarranger.py --replace-fail \
      "return 'libintl.8.dylib'" \
      "return '$LINTL'"
    unset LINTL
  '';

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    gtk3
    poppler
    libhandy
  ];

  dependencies = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
    python-dateutil
  ];

  # incompatible with wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  doCheck = false; # no tests

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using a graphical interface";
    mainProgram = "pdfarranger";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${finalAttrs.src.tag}";
  };
})
