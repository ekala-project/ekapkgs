{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  cups,
  libpng,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "htmldoc";
  version = "1.9.23";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "htmldoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GUJ5qNqNfjkzZMNGMj/w53wso6X1WOooJNE6drKqHks=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zlib
    cups
    libpng
    libjpeg
  ];

  meta = {
    description = "Converts HTML files to PostScript and PDF";
    homepage = "https://michaelrsweet.github.io/htmldoc";
    changelog = "https://github.com/michaelrsweet/htmldoc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
    mainProgram = "htmldoc";
  };
})
