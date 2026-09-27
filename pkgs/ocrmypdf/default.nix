{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  installShellFiles,
  ghostscript,
  jbig2enc,
  pngquant,
  tesseract,
  unpaper,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ocrmypdf";
  version = "17.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocrmypdf";
    repo = "OCRmyPDF";
    tag = "v${finalAttrs.version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/ocrmypdf/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-eKDJE9QNV2e6mYQ1JkbpGJbSnwLZmBrt74LLLNS0LVw=";
  };

  patches = [
    (replaceVars ./paths.patch {
      gs = lib.getExe ghostscript;
      jbig2 = lib.getExe jbig2enc;
      pngquant = lib.getExe pngquant;
      tesseract = lib.getExe tesseract;
      unpaper = lib.getExe unpaper;
    })
  ];

  # Remove pi-heif from required dependencies since libheif/pillow-heif
  # fail to build in corepkgs. The pyproject.toml comment says removing
  # it "will NOT break" ocrmypdf, and the source handles the missing
  # import gracefully via try/except.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pi-heif",' ""
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    deprecation
    fpdf2
    img2pdf
    packaging
    pdfminer-six
    pikepdf
    pillow
    pluggy
    pydantic
    pypdfium2
    rich
    uharfbuzz
  ];

  doCheck = false;

  pythonImportsCheck = [ "ocrmypdf" ];

  postInstall = ''
    installShellCompletion --cmd ocrmypdf \
      --bash misc/completion/ocrmypdf.bash \
      --fish misc/completion/ocrmypdf.fish
  '';

  meta = {
    homepage = "https://github.com/ocrmypdf/OCRmyPDF";
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched";
    license = with lib.licenses; [
      mpl20
      mit
    ];
    changelog = "https://github.com/ocrmypdf/OCRmyPDF/blob/${finalAttrs.src.tag}/docs/releasenotes/version17.md";
    mainProgram = "ocrmypdf";
  };
})
