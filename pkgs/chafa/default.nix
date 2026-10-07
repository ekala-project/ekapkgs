{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  autoconf,
  automake,
  libtool,
  pkg-config,
  which,
  libavif,
  libjxl,
  librsvg,
  libxslt,
  libxml2,
  docbook-xml-dtd,
  docbook_xsl,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.18.3";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    tag = finalAttrs.version;
    hash = "sha256-lMpofiJ6Hhxqna5OMWAG4tp7i2O/RZcimyaZsYsGu+c=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "out"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    which
    libxslt
    libxml2
    docbook-xml-dtd.v4_1_2
    docbook_xsl
    installShellFiles
  ];

  buildInputs = [
    glib
    libavif
    libjxl
    librsvg
  ];

  patches = [ ./xmlcatalog_patch.patch ];

  preConfigure = ''
    substituteInPlace ./autogen.sh --replace pkg-config '$PKG_CONFIG'
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--enable-man"
    "--with-xml-catalog=${docbook-xml-dtd.v4_1_2}/xml/dtd/docbook/catalog.xml"
  ];

  postInstall = ''
    installShellCompletion --cmd chafa \
      --fish tools/completions/fish-completion.fish \
      --zsh tools/completions/zsh-completion.zsh
  '';

  meta = {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "chafa";
  };
})
