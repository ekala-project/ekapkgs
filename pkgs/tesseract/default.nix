{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  leptonica,
  libarchive,
  libpng,
  libtiff,
  icu,
  pango,
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-n+ZtLAVi6+dOusK040i/sSjJqw58Ef62uTeimYbMUHk=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    curl
    leptonica
    libarchive
    libpng
    libtiff
    icu
    pango
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "tesseract";
  };
}
